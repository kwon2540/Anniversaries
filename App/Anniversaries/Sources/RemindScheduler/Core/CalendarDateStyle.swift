//
//  Created by Maharjan Binish on 2023/07/30.
//

import Foundation

struct CalendarDateStyle: FormatStyle {
    public func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.timeStyle = .none
        formatter.dateStyle = .full

        return formatter.string(from: value)
    }
}

extension FormatStyle where Self == CalendarDateStyle {
    static var calendarDate: CalendarDateStyle { .init() }
}
