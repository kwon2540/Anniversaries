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
    
    struct ViewState: Equatable {
        @BindingViewState var editMode: EditMode
        var groupedAnniversariesList: [GroupedAnniversaries]
        var currentSort: Sort.Kind
        var currentSortOrder: Sort.Order
        
        init(store: BindingViewStore<Home.State>) {
            self._editMode = store.$editMode
            self.groupedAnniversariesList = store.groupedAnniversariesList
            self.currentSort = store.currentSort
            self.currentSortOrder = store.currentSortOrder
        }
    }

    private var store: StoreOf<Home>

    public var body: some View {
        WithViewStore(store, observe: ViewState.init) { viewStore in
            NavigationStack {
                List {
                    ForEach(viewStore.groupedAnniversariesList, id: \.self) { groupedAnniversaries in
                        Section {
                            ForEach(groupedAnniversaries.anniversaries, id: \.self) { anniversary in
                                Button {
                                    viewStore.send(.anniversaryTapped(anniversary))
                                } label: {
                                    Item(anniversary: anniversary)
                                }
                            }
                            .onDelete { indexSet in
                                guard let index = indexSet.first else {
                                    return
                                }
                                let anniversary = groupedAnniversaries.anniversaries[index]
                                viewStore.send(.onDeleteAnniversary(anniversary))
                            }
                            
                        } header: {
                            Text(groupedAnniversaries.key)
                                .font(.title2)
                                .foregroundStyle(Color.black)
                                .padding(.leading, -16)
                        }
                        .textCase(nil)
                    }
                }
                .navigationTitle(#localized("Anniversaries"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if viewStore.editMode == .inactive {
                            menu(viewStore: viewStore)
                        } else {
                            editDoneButton(viewStore: viewStore)
                        }
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        addButton(viewStore: viewStore)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .environment(\.editMode, viewStore.$editMode)
                .sheet(
                    store: store.scope(state: \.$destination, action: Home.Action.destination),
                    state: /Home.Destination.State.add,
                    action: Home.Destination.Action.add,
                    content: AddView.init(store:)
                )
                .navigationDestination(
                    store: store.scope(state: \.$destination, action: Home.Action.destination),
                    state: /Home.Destination.State.edit,
                    action: Home.Destination.Action.edit,
                    destination: EditView.init(store:)
                )
                .modelContainer(anniversaryContainer)
            }
        }
    }

    // MARK: Tools
    private func menu(viewStore: ViewStore<ViewState, Home.Action>) -> some View {
        Menu {
            Button {
                viewStore.send(.editButtonTapped, animation: .default)
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
            
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundColor(#color("black"))
        }
    }
    
    private func editDoneButton(viewStore: ViewStore<ViewState, Home.Action>) -> some View {
        Button {
            viewStore.send(.editDoneButtonTapped, animation: .default)
        } label: {
            Text(#localized("Done"))
        }
    }

    private func addButton(viewStore:  ViewStore<ViewState, Home.Action>) -> some View {
        Group {
            Spacer()

            Button {
                viewStore.send(.addButtonTapped)
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(#color("black"))
            }
            .buttonStyle(.plain)
        }
    }
}

private struct Item: View {
    var anniversary: Anniversary

    var body: some View {
        LabeledContent {
            chevron
        } label: {
            VStack(spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    name
                    Spacer()
                    date
                }
                // reminds, memoどっちもいない場合にspacingだけ取られているため
                if !anniversary.reminds.isEmpty || !anniversary.memo.isEmpty {
                    VStack {
                        if !anniversary.reminds.isEmpty {
                            reminds
                        }
                        if !anniversary.memo.isEmpty {
                            memo
                        }
                    }
                    .font(.subheadline)
                }
            }
            .foregroundStyle(Color.black)
            .lineLimit(1)
        }
    }

    private var name: some View {
        Text(anniversary.name)
            .font(.title3)
            .bold()
    }

    private var date: some View {
        Text(anniversary.date.formatted(date: .numeric, time: .omitted))
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(Color.gray)
    }

    private var reminds: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(#localized("Remind")): ")
                .bold()
                .foregroundStyle(Color.gray)
            +
            Text(anniversary.remindDate)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var memo: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(#localized("Memo")): ")
                .bold()
                .foregroundStyle(Color.gray)
            +
            Text(anniversary.memo)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .resizable()
            .scaledToFit()
            .frame(height: 12)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: .init(
                initialState: .init(),
                reducer: Home.init
            )
        )
    }
}
