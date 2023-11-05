//
//  Created by クォン ジュンヒョク on 2023/11/05.
//

import Foundation
import SwiftDataClient

extension Anniversary {
    var month: Date.FormatStyle.FormatOutput {
        date.formatted(.dateTime.month())
    }

    var digitsMonth: Int {
        Int(date.formatted(.dateTime.month(.defaultDigits))) ?? 0
    }

    var remindDate: String {
        reminds
            .map { $0.date.formatted(.remindDate) }
            .joined(separator: " / ")
    }
}
