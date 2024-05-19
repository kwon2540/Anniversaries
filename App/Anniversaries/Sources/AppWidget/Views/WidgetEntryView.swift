//
//  Created by マハルジャン ビニシュ on 2024/04/28.
//

import SwiftUI
import WidgetKit

struct WidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: AnniversaryProvider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .accessoryRectangular:
            RectangularWidgetView(entry: entry)
        default:
            EmptyView()
        }
    }
}
