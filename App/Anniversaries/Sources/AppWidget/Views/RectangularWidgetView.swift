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
            VStack(alignment: .leading) {
                HStack {
                    #image(entry.imageName)
                        .resizable()
                        .frame(width: 28, height: 28)
                    Text("\(entry.targetDate.daysRemaining) Days Left")
                        .font(.system(size: 18).bold())
                        .minimumScaleFactor(0.5)
                }
                VStack(alignment: .center) {
                    Text(entry.name)
                    Text(entry.anniversaryDate.formatted(date: .abbreviated, time: .omitted))
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

