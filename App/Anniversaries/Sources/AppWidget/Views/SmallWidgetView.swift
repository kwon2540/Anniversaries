//
//  Created by マハルジャン ビニシュ on 2024/04/28.
//

import SwiftUI
import AppUI

struct SmallWidgetView: View {
    
    var entry: AnniversaryEntry
    
    var body: some View {
        if entry.isEmpty {
            Text("No Anniversary")
        } else {
            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text(entry.title)
                        .font(.footnote)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(entry.daysRemaining)
                            .font(.system(size: 60, weight: .bold))
                            .minimumScaleFactor(0.5)
                        if !entry.anniversaryDate.hasSameMonthAndDayAsToday {
                            Text(#localized("Days Left"))
                                .font(.system(size: 10))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                
                VStack {
                    Text(entry.name)
                        .lineLimit(1)
                        .bold()
                
                    Text(entry.anniversaryDate.formatted(.widgetDate))
                        .font(.footnote)
                }
                .minimumScaleFactor(0.5)
                .font(.subheadline)
            }
        }
    }
}

#Preview {
    SmallWidgetView(entry: AnniversaryEntry(date: .now, kind: .birth, title: "Birthday", name: "John Appleseed", anniversaryDate: .now, isEmpty: false))
}
