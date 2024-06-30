//
//  Created by マハルジャン ビニシュ on 2024/05/19.
//

import Foundation
import SwiftDataClient
import WidgetKit
import CoreKit

struct AnniversaryEntry: TimelineEntry {
    /// The date for WidgetKit to render a widget.
    var date: Date
    var kind: AnniversaryKind
    var title: String
    var name: String
    var anniversaryDate: Date
    var isEmpty: Bool
    
    var imageName: String {
        return switch kind {
        case .birth: "icon_birthday"
        case .remembrance: "icon_remembrance"
        case .others: "icon_others"
        }
    }
}

extension AnniversaryEntry {
    init(date: Date, anniversary: Anniversary) {
        self.date = date
        self.kind = anniversary.kind
        self.title = anniversary.kind == .others ? anniversary.othersTitle : anniversary.kind.title
        self.name = anniversary.name
        self.anniversaryDate = anniversary.date
        self.isEmpty = false
    }
}

extension Date {
    var daysRemaining: String {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: .now)
        let targetDate = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.day], from: now, to: targetDate)
        return String(components.day ?? 0)
    }
}
