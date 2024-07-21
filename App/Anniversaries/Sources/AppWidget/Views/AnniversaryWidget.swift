//
//  Created by マハルジャン ビニシュ on 2024/04/28.
//

import WidgetKit
import SwiftUI
import AppUI

public struct AnniversaryWidget: Widget {
    public init() { }

    let kind: String = "AnniversaryWidget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AnniversaryProvider()) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName(#localized("Nearest Anniversary"))
        .description(#localized("Displays the nearest anniversary."))
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    AnniversaryWidget()
} timeline: {
    AnniversaryEntry(date: .now, kind: .birth, title: "Birthday", name: "John Appleseed", anniversaryDate: .now, isEmpty: false)
    AnniversaryEntry(date: .now, kind: .birth, title: "Birthday", name: "John Appleseed Jr", anniversaryDate: .now, isEmpty: false)
}
