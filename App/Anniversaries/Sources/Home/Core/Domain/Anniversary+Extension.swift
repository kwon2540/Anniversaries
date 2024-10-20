//
//  Created by クォン ジュンヒョク on 2023/11/05.
//

import Foundation
import SwiftDataClient
import CoreKit
import AppUI

extension Anniversary {
    var month: Date.FormatStyle.FormatOutput {
        date.formatted(.dateTime.month())
    }

    var digitsMonth: Int {
        Int(date.formatted(.twoDigits)) ?? 0
    }

    var remindDate: String {
        reminds
            .map { $0.date.formatted(.remindDate) }
            .joined(separator: " / ")
    }

    var nthTitle: String {
        let prefix = "\(date.nthAnniversary.ordinalString) "
        return kind == .others ? prefix + othersTitle : prefix + kind.title
    }
}

extension Array where Element == Anniversary {
    func sorted(by kind: Sort.Kind, order: Sort.Order) -> [GroupedAnniversaries] {
        switch kind {
        case .defaultCategory:
            // AnniversaryKindをKeyでGroupしている
            var anniversariesDictionary: [AnniversaryKind: [Anniversary]] = Dictionary(
                grouping: self,
                by: { $0.kind }
            )
            // anniversariesDictionaryのValueを名前順にソートする
            anniversariesDictionary.forEach {
                anniversariesDictionary[$0] = $1.sorted(using: KeyPathComparator(\.name))
            }
            // AnniversaryKindのIntのRawValueでソートを行なっている
            let sortedGroupedAnniversaries = anniversariesDictionary
                .sorted {
                    $0.key.rawValue < $1.key.rawValue
                }
                .map(GroupedAnniversaries.init(element:))
            return order == .ascending ? sortedGroupedAnniversaries : sortedGroupedAnniversaries.reversed()
        case .date:
            // Date.FormatStyle.FormatOutput(String)をKeyでGroupしている
            var anniversariesDictionary: [Date.FormatStyle.FormatOutput: [Anniversary]] = Dictionary(
                grouping: self,
                by: { $0.month }
            )
            // anniversariesDictionaryのValueを名前順にソートする
            anniversariesDictionary.forEach {
                anniversariesDictionary[$0] = $1.sorted(using: KeyPathComparator(\.name))
            }
            // Date.FormatStyle.FormatOutput(String)ではソートがうまくできないため、digitsMonthを利用するソートを行なっている
            let sortedGroupedAnniversaries = anniversariesDictionary
                .sorted {
                    $0.value.first?.digitsMonth ?? 0 < $1.value.first?.digitsMonth ?? 0
                }
                .map(GroupedAnniversaries.init(element:))
            return order == .ascending ? sortedGroupedAnniversaries : sortedGroupedAnniversaries.reversed()
        case .name:
            guard !self.isEmpty else {
                return []
            }
            
            let sortedAnniversaries = self
                .sorted(using: KeyPathComparator(\.name, order: order == .ascending ? .forward : .reverse))
            return [GroupedAnniversaries(key: #localized("Name"), anniversaries: sortedAnniversaries)]
        }
    }
}

private extension Int {
    var ordinalString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

private extension Date {
    var nthAnniversary: Int {
        let calendar = Calendar.current

        let anniversaryDateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let futureDateComponents = calendar.dateComponents([.year, .month, .day], from: .now)

        // Calculate the difference in years between the future date and the anniversary
        guard let anniversaryYear = anniversaryDateComponents.year,
              let futureYear = futureDateComponents.year else {
            return 0
        }

        var anniversary = futureYear - anniversaryYear

        // If the future date is before the anniversary date in the same year, subtract one from the anniversary
        if (futureDateComponents.month! < anniversaryDateComponents.month!) ||
            (futureDateComponents.month == anniversaryDateComponents.month && futureDateComponents.day! < anniversaryDateComponents.day!) {
            anniversary -= 1
        }

        // If the future date matches the anniversary date (same month and day), keep the anniversary the same
        if futureDateComponents.month == anniversaryDateComponents.month &&
            futureDateComponents.day == anniversaryDateComponents.day {
            anniversary -= 1
        }

        return anniversary + 1
    }
}
