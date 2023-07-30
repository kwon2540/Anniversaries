//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import Home
import SwiftUI

public struct RootView: View {
    public init(store: StoreOf<Root>) {
        self.store = store
    }
    
    private let store: StoreOf<Root>

    public var body: some View {
        IfLetStore(store.scope(state: \.launchState, action: Root.Action.launchAction), then: LaunchView.init(store:))
        IfLetStore(store.scope(state: \.homeState, action: Root.Action.homeAction), then: HomeView.init(store:))
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                initialState: .init(),
                reducer: Root.init
            )
        )
    }
}
