//
//  Created by マハルジャン ビニシュ on 2024/04/28.
//

import WidgetKit
import SwiftUI

public struct AnniversaryWidget: Widget {
    public init() { }

    let kind: String = "AnniversaryWidget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AnniversaryProvider()) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    AnniversaryWidget()
} timeline: {
    AnniversaryEntry(date: .now, kind: .birth, title: "Birthday", name: "John Appleseed", targetDate: .now, isEmpty: false)
    AnniversaryEntry(date: .now, kind: .birth, title: "Birthday", name: "John Appleseed Jr", targetDate: .now, isEmpty: false)
}
