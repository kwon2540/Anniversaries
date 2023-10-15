//
//  Created by Maharjan Binish on 2023/03/05.
//

import AddAndEdit
import AppUI
import ComposableArchitecture
import CoreKit
import SwiftData
import SwiftDataClient
import SwiftUI

private extension Sort.Kind {
    var title: String {
        switch self {
        case .defaultCategory:
            return #localized("Default(Category)")
        case .date:
            return #localized("Date")
        case .name:
            return #localized("Name")
        }
    }
}

private extension Sort.Order {
    var title: String {
        switch self {
        case .ascending:
            return #localized("Ascending")
        case .descending:
            return #localized("Descending")
        }
    }
}

public struct HomeView: View {
    public init(store: StoreOf<Home>) {
        self.store = store
    }

    private var store: StoreOf<Home>

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                List {
//                    ForEach(viewStore.anniversaries) { anniversary in
//                        Text(anniversary.name)
//                    }
                }
                .navigationTitle(#localized("Anniversaries"))
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
                .sheet(
                    store: store.scope(state: \.$destination, action: Home.Action.destination),
                    state: /Home.Destination.State.anniversary,
                    action: Home.Destination.Action.anniversary,
                    content: AddAndEditView.init(store:)
                )
                .modelContainer(anniversaryContainer)
            }
        }
    }

    private func menu(viewStore: ViewStoreOf<Home>) -> some View {
        Menu {
            Button {
                viewStore.send(.editButtonTapped)
            } label: {
                Label(#localized("Edit"), systemImage: "pencil")
            }

            Menu {
                ForEach(Sort.Kind.allCases, id: \.self) { sort in
                    Toggle(
                        sort.title,
                        isOn: viewStore.binding(
                            get: { $0.currentSort == sort },
                            send: .sortByButtonTapped(sort)
                        )
                    )
                }

                Divider()

                ForEach(Sort.Order.allCases, id: \.self) { sortOrder in
                    Toggle(
                        sortOrder.title,
                        isOn: viewStore.binding(
                            get: { $0.currentSortOrder == sortOrder },
                            send: .sortOrderButtonTapped(sortOrder)
                        )
                    )
                }
            } label: {
                Label(#localized("Sort By"), systemImage: "arrow.up.arrow.down")
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
                    themeState: .init()
                ),
                reducer: Home.init
            )
        )
    }
}
