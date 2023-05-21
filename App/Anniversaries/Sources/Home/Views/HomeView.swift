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
                .onAppear {
                    viewStore.send(.onAppear)
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
                Toggle(
                    "Default(Date)",
                    isOn: viewStore.binding(
                        get: { $0.currentSort == .defaultDate },
                        send: .sortByButtonTapped(.defaultDate)
                    )
                )

                Toggle(
                    "Date",
                    isOn: viewStore.binding(
                        get: { $0.currentSort == .date },
                        send: .sortByButtonTapped(.date)
                    )
                )

                Toggle(
                    "Created",
                    isOn: viewStore.binding(
                        get: { $0.currentSort == .created },
                        send: .sortByButtonTapped(.created)
                    )
                )

                Toggle(
                    "Name",
                    isOn: viewStore.binding(
                        get: { $0.currentSort == .name },
                        send: .sortByButtonTapped(.name)
                    )
                )

                Divider()

                Toggle(
                    "Newest First",
                    isOn: viewStore.binding(
                        get: { $0.currentSortOrder == .newest },
                        send: .sortOrderButtonTapped(.newest)
                    )
                )

                Toggle(
                    "Oldest First",
                    isOn: viewStore.binding(
                        get: { $0.currentSortOrder == .oldest },
                        send: .sortOrderButtonTapped(.oldest)
                    )
                )
            } label: {
                Label("Sort By", systemImage: "arrow.up.arrow.down")
            }

            Menu {
                Toggle(
                    "Default(Midnight Sky)",
                    isOn: viewStore.binding(
                        get: { $0.themeState.currentPreset == .default },
                        send: .themeButtonTapped(.default)
                    )
                )

                Toggle(
                    "Midnight Sky",
                    isOn: viewStore.binding(
                        get: { $0.themeState.currentPreset == .midnightSky },
                        send: .themeButtonTapped(.midnightSky)
                    )
                )

                Toggle(
                    "Sunrise Glow",
                    isOn: viewStore.binding(
                        get: { $0.themeState.currentPreset == .sunriseGlow },
                        send: .themeButtonTapped(.sunriseGlow)
                    )
                )

                Toggle(
                    "Forest Walk",
                    isOn: viewStore.binding(
                        get: { $0.themeState.currentPreset == .forestWalk },
                        send: .themeButtonTapped(.forestWalk)
                    )
                )

                Toggle(
                    "Cherry Blossom",
                    isOn: viewStore.binding(
                        get: { $0.themeState.currentPreset == .cherryBlossom },
                        send: .themeButtonTapped(.cherryBlossom)
                    )
                )

                Toggle(
                    "Ocean Breeze",
                    isOn: viewStore.binding(
                        get: { $0.themeState.currentPreset == .oceanBreeze },
                        send: .themeButtonTapped(.oceanBreeze)
                    )
                )
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
