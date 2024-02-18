//
//  Created by Maharjan Binish on 2023/03/05.
//

import AddAndEdit
import Detail
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
    
    @Bindable private var store: StoreOf<Home>
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(store.groupedAnniversariesList, id: \.self) { groupedAnniversaries in
                    Section {
                        ForEach(groupedAnniversaries.anniversaries, id: \.self) { anniversary in
                            Button {
                                store.send(.anniversaryTapped(anniversary))
                            } label: {
                                Item(anniversary: anniversary, editMode: store.editMode)
                            }
                        }
                        .onDelete { indexSet in
                            guard let index = indexSet.first else {
                                return
                            }
                            let anniversary = groupedAnniversaries.anniversaries[index]
                            store.send(.onDeleteAnniversary(anniversary))
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
            .disabled(store.editMode == .active)
            .navigationTitle(#localized("Anniversaries"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if store.editMode == .inactive {
                        menu
                    } else {
                        editDoneButton
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    addButton
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
            .environment(\.editMode, $store.editMode)
            .sheet(
                item: $store.scope(state: \.destination?.add, action: \.destination.add),
                content: AddView.init(store:)
            )
            .navigationDestination(
                item: $store.scope(state: \.destination?.detail, action: \.destination.detail),
                destination: DetailView.init(store:)
            )
            .alert(
                $store.scope(state: \.destination?.alert, action: \.destination.alert)
            )
            .modelContainer(anniversaryContainer)
        }
    }

    // MARK: Tools
    private var menu: some View {
        Menu {
            Button {
                store.send(.editButtonTapped, animation: .default)
            } label: {
                Label(#localized("Edit"), systemImage: "pencil")
            }

            Menu {
                ForEach(Sort.Kind.allCases, id: \.self) { sort in
                    Toggle(
                        sort.title,
                        isOn: $store.currentSort.sending(\.sortByButtonTapped).isOn(sort: sort)
                    )
                }

                Divider()

                ForEach(Sort.Order.allCases, id: \.self) { sortOrder in
                    Toggle(
                        sortOrder.title,
                        isOn: $store.currentSortOrder.sending(\.sortOrderButtonTapped).isOn(sortOrder: sortOrder)
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
    
    private var editDoneButton: some View {
        Button {
            store.send(.editDoneButtonTapped, animation: .default)
        } label: {
            Text(#localized("Done"))
        }
    }
    
    private var addButton: some View {
        Group {
            Spacer()
            
            Button {
                store.send(.addButtonTapped)
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
    var editMode: EditMode
    
    var body: some View {
        LabeledContent {
            if editMode == .inactive { chevron }
        } label: {
            VStack(spacing: 8) {
                if !anniversary.othersTitle.isEmpty {
                    HStack {
                        othersTitle(anniversary.othersTitle)
                        Spacer()
                        date
                    }
                }
                
                HStack(alignment: .firstTextBaseline) {
                    name
                    Spacer()
                    if anniversary.othersTitle.isEmpty {
                        date
                    }
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
    
    private func othersTitle(_ title: String) -> some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
            .bold()
            .foregroundStyle(Color.gray)
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
