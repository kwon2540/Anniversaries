//
//  Created by マハルジャン ビニシュ on 2023/12/24.
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
}

private extension Date {
    init(dateComponents: DateComponents) {
        let calendar = dateComponents.calendar ?? Calendar.current
        self = calendar.date(from: dateComponents)!
    }
}
