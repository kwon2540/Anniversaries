//
//  Created by Maharjan Binish on 2023/03/05.
//

import AppUI
import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    public init(store: StoreOf<Home>) {
        self.store = store
    }

    private var store: StoreOf<Home>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView{
                    Text(L10n.Home.title)
                }
                .navigationTitle(L10n.Home.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        menu(viewStore: viewStore)
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        addButton(viewStore: viewStore)
                    }
                }
            }
        }
    }

    private func menu(viewStore: ViewStoreOf<Home>) -> some View {
        Menu {
            Button {
                viewStore.send(.editButtonTapped)
            } label: {
                Label("Edit", systemImage: "pencil")
            }

            Menu {
                Button("Default(Date)") {
                    viewStore.send(.sortByButtonTapped(.date))
                }
                Button("Date") {
                    viewStore.send(.sortByButtonTapped(.date))
                }
                Button("Created") {
                    viewStore.send(.sortByButtonTapped(.created))
                }
                Button("Name") {
                    viewStore.send(.sortByButtonTapped(.name))
                }
            } label: {
                Label("Sort By", systemImage: "arrow.up.arrow.down")
            }

            Menu {
                Button("Default(Midnight Sky)") {
                    viewStore.send(.themeButtonTapped(.midnightSky))
                }
                Button("Midnight Sky") {
                    viewStore.send(.themeButtonTapped(.midnightSky))
                }
                Button("Sunrise Glow") {
                    viewStore.send(.themeButtonTapped(.sunriseGlow))
                }
                Button("Forest Walk") {
                    viewStore.send(.themeButtonTapped(.forestWalk))
                }
                Button("Cherry Blossom") {
                    viewStore.send(.themeButtonTapped(.cherryBlossom))
                }
                Button("Ocean Breeze") {
                    viewStore.send(.themeButtonTapped(.oceanBreeze))
                }
            } label: {
                Label("Theme", systemImage: "paintpalette")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundColor(viewStore.themeState.backgroundColor)
        }
    }

    private func addButton(viewStore: ViewStoreOf<Home>) -> some View {
        Group {
            Spacer()

            Button {
                viewStore.send(.addButtonTapped)
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(viewStore.themeState.backgroundColor)
            }
            .buttonStyle(.plain)
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
