//
//  Created by Maharjan Binish on 2023/07/16.
//

import SwiftUI

public struct FormIcon: View {
    private var backgroundColor: String
    private var systemName: String

    public init(backgroundColor: String, systemName: String) {
        self.backgroundColor = backgroundColor
        self.systemName = systemName
    }

    public var body: some View {
        #color(backgroundColor)
            .frame(width: 24, height: 24)
            .cornerRadius(4)
            .overlay {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .padding(4)
                    .foregroundColor(.white)
            }
    }
}

#Preview {
    LazyVGrid(
        columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
        spacing: 8) {
            FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
            FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
            FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
            FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
            FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
            FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
            FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
        }
}


