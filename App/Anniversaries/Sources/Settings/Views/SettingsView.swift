//
//  Created by Maharjan Binish on 2023/04/16.
//

import SwiftUI
import ComposableArchitecture

public struct SettingsView: View {
    public init(store: StoreOf<Settings>) {
        self.store = store
    }
    
    var store: StoreOf<Settings>

    public var body: some View {
        NavigationView {

            Text("Settings View")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            store: .init(
                initialState: .init(
                    themeState: .init()
                ),
                reducer: Settings()
            )
        )
    }
}
