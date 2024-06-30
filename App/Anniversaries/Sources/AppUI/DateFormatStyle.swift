//
//  Created by クォン ジュンヒョク on 2023/10/29.
//

import Foundation

public enum DateFormatStyle {
    public struct RemindDate: FormatStyle {
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
    
    public struct WidgetDate: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = "yyyy/MM/dd"
            
            return formatter.string(from: value)
        }
    }
}

extension FormatStyle where Self == DateFormatStyle.RemindDate {
    public static var remindDate: DateFormatStyle.RemindDate { .init() }
}

extension FormatStyle where Self == DateFormatStyle.WidgetDate {
    public static var widgetDate: DateFormatStyle.WidgetDate { .init() }
}
