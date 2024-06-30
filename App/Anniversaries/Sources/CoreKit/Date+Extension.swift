//
//  Created by マハルジャン ビニシュ on 2024/06/23.
//

import Foundation

extension Date {
    public var nearestFutureDate: Date {
        let currentYear = Calendar.current.component(.year, from: .now)
        let month = Calendar.current.component(.month, from: self)
        let day = Calendar.current.component(.day, from: self)
        
        let thisYearDate = Date(dateComponents: .init(year: currentYear, month: month, day: day))
        let year = (thisYearDate > .now) ? currentYear : currentYear + 1
        return Date(dateComponents: .init(year: year, month: month, day: day))
    }

    public var hasSameMonthAndDayAsToday: Bool {
        let month = Calendar.current.component(.month, from: self)
        let day = Calendar.current.component(.day, from: self)
        let nowMonth = Calendar.current.component(.month, from: .now)
        let nowDay = Calendar.current.component(.day, from: .now)
        
        return month == nowMonth && day == nowDay
    }
    
    public var daysRemaining: String {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: .now)
        let targetDate = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.day], from: now, to: targetDate)
        return String(components.day ?? 0)
    }
}

private extension Date {
    init(dateComponents: DateComponents) {
        let calendar = dateComponents.calendar ?? Calendar.current
        self = calendar.date(from: dateComponents)!
    }
}
