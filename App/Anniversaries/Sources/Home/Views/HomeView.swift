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
            NavigationView {
                ScrollView {
                    VStack {
                        Text(L10n.Home.title)
                            .frame(height: 1000)
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationDestination(
                    isPresented: Binding(
                        get: { viewStore.settingsState != nil },
                        set: { isPresented in
                            if !isPresented, viewStore.settingsState != nil {
                                viewStore.send(.dismissSettings)
                            }
                        }
                    ), destination: {
                        IfLetStore(store.scope(state: \.settingsState, action: Home.Action.settingsAction)) { store in
                            SettingsView(store: store)
                        }
                    }
                )
                .searchable(text: viewStore.binding(\.$searchText))
                .onSubmit(of: .search) {
                    viewStore.send(.searchButtonTapped)
                }
                .navigationTitle("Anniversaries")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button {
                            viewStore.send(.settingsButtonTapped)
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
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
