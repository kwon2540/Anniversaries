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
        SwitchStore(store) {
            CaseLet(state: /Root.State.launch, action: Root.Action.launchAction) { store in
                LaunchView(store: store)
            }
            CaseLet(state: /Root.State.home, action: Root.Action.homeAction) { store in
                HomeView(store: store)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                initialState: .init(),
                reducer: Root()
            )
        )
    }
}
