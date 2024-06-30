//
//  Created by マハルジャン ビニシュ on 2024/04/28.
//

import SwiftUI
import AppUI

struct RectangularWidgetView: View {
    
    var entry: AnniversaryEntry
    
    var body: some View {
        if entry.isEmpty {
            Text("No Anniversary")
        } else {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    #image(entry.imageName)
                        .resizable()
                        .frame(width: 28, height: 28)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(entry.daysRemaining)")
                            .font(.system(size: 18))
                            .bold()
                            .minimumScaleFactor(0.5)
                        if !entry.anniversaryDate.hasSameMonthAndDayAsToday {
                            Text(#localized("Days Left"))
                                .bold()
                        }
                    }
                }
                VStack(alignment: .center) {
                    Text(entry.name)
                        .font(.system(size: 20))
                        .bold()
                    Text(entry.anniversaryDate.formatted(.widgetDate))
                        .font(.system(size: 20))
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .minimumScaleFactor(0.5)
            }
        }
    }
}

#Preview {
    RectangularWidgetView(entry: AnniversaryEntry(date: .now, kind: .birth, title: "Birthday", name: "John Appleseed", anniversaryDate: .now, isEmpty: false))
}

