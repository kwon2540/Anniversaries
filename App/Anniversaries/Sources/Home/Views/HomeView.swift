//
//  Created by Maharjan Binish on 2023/03/05.
//

import AppUI
import ComposableArchitecture
import SwiftUI
import Settings

public struct HomeView: View {
    public init(store: StoreOf<Home>) {
        self.store = store
    }

    var store: StoreOf<Home>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView{
                    Text(L10n.Home.title)
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.settingsButtonTapped)
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundColor(Asset.Colors.black.swiftUIColor)
                        }
                    }
                }
                .navigationDestination(
                    store: store.scope(state: \.$destination, action: Home.Action.destination),
                    state: /Home.Destination.State.settings,
                    action: Home.Destination.Action.settingsAction
                ) { store in
                    SettingsView(store: store)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: .init(
                initialState: .init(
                    anniversaries: "Anniversaries",
                    themeState: .init()
                ),
                reducer: Home()
            )
        )
    }
}
