//
//  Created by クォン ジュンヒョク on 2023/10/29.
//

import Foundation

struct RemindDateStyle: FormatStyle {
    public func format(_ value: Date) -> String {
        let formatStyle = Date.FormatStyle()
            .year()
            .month()
            .day()
            .weekday()
            .hour()
            .minute()
        return formatStyle.format(value)
    }
}

extension FormatStyle where Self == RemindDateStyle {
    static var remindDate: RemindDateStyle { .init() }
}
