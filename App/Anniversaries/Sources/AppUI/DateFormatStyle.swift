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

    public struct RemindDateNoYear: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatStyle = Date.FormatStyle()
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

    public struct TwoDigitsStyle: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = "MM"

            return formatter.string(from: value)
        }
    }

    public struct AnniversaryDateStyle: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = DateFormatter()
            let languageCode = Locale.current.language.languageCode?.identifier
            switch languageCode {
            case "ko", "ja":
                formatter.dateStyle = .long
            default:
                formatter.dateStyle = .medium
            }

            return formatter.string(from: value)
        }
    }
}

extension FormatStyle where Self == DateFormatStyle.RemindDate {
    public static var remindDate: DateFormatStyle.RemindDate { .init() }
}

extension FormatStyle where Self == DateFormatStyle.RemindDateNoYear {
    public static var remindDateNoYear: DateFormatStyle.RemindDateNoYear { .init() }
}

extension FormatStyle where Self == DateFormatStyle.WidgetDate {
    public static var widgetDate: DateFormatStyle.WidgetDate { .init() }
}

extension FormatStyle where Self == DateFormatStyle.TwoDigitsStyle {
    public static var twoDigits: DateFormatStyle.TwoDigitsStyle { .init() }
}

extension FormatStyle where Self == DateFormatStyle.AnniversaryDateStyle {
    public static var anniversaryDate: DateFormatStyle.AnniversaryDateStyle { .init() }
}
