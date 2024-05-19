//
//  Created by マハルジャン ビニシュ on 2024/04/28.
//

import SwiftUI

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
                        Text(entry.targetDate.daysRemaining)
                            .font(.system(size: 60, weight: .bold))
                            .minimumScaleFactor(0.5)
                        Text("日前")
                    }
                }
                
                VStack {
                    Text(entry.name)
                        .bold()
                
                    Text(entry.targetDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                }
                .minimumScaleFactor(0.5)
                .font(.subheadline)
            }
        }
    }
}

#Preview {
    SmallWidgetView(entry: AnniversaryEntry(date: .now, kind: .birth, title: "Birthday", name: "John Appleseed", targetDate: .now, isEmpty: false))
}
