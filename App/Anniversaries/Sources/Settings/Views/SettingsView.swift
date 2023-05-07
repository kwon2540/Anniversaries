//
//  Created by Maharjan Binish on 2023/05/07.
//

import ComposableArchitecture
import SwiftUI

public struct SettingsView: View {
    public init(store: StoreOf<Settings>) {
        self.store = store
    }

    private var store: StoreOf<Settings>

    public var body: some View {
        Text("Settings")
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            store: .init(initialState: .init(), reducer: Settings())
        )
    }
}
