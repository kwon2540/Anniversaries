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

        IfLetStore(store.scope(state: \.destination, action: Root.Action.destination)) { store in
            SwitchStore(store) { state in
                switch state {
                case .launch:
                    CaseLet(state: /Root.Destination.State.launch, action: Root.Destination.Action.launchAction) { launchStore in
//                        LaunchView(store: launchStore)
                        Text("Launch")
                    }

                case .home:
                    CaseLet(state: /Root.Destination.State.home, action: Root.Destination.Action.homeAction) { homeStore in
//                        HomeView(store: homeStore)
                        Text("Home")
                    }
                }
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
