//
//  Created by Maharjan Binish on 2023/03/05.
//

import AddAndEdit
import Detail
import License
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
                            .foregroundStyle(#color("#000000"))
                            .padding(.leading, -16)
                    }
                    .textCase(nil)
                }
            }
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
            .sheet(
                item: $store.scope(state: \.destination?.license, action: \.destination.license),
                content: LicenseView.init(store:)
            )
            .alert(
                $store.scope(state: \.destination?.alert, action: \.destination.alert)
            )
            .onOpenURL { id in
                store.send(.widgetTapped(id: id.absoluteString))
            }
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
            
            Button {
                store.send(.licenseButtonTapped, animation: .default)
            } label: {
                Text(#localized("License"))
            }
            
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundColor(#color("#000000"))
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
                    .foregroundColor(#color("#000000"))
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
                HStack {
                    nthTitle(anniversary.nthTitle)
                    Spacer()
                    date
                }

                name
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !anniversary.reminds.isEmpty || !anniversary.memo.isEmpty {
                    HStack {
                        if !anniversary.reminds.isEmpty {
                            TagView(type: .remind)
                        }
                        if !anniversary.memo.isEmpty {
                            TagView(type: .memo)
                        }
                        Spacer()
                    }
                }
            }
            .foregroundStyle(#color("#000000"))
            .lineLimit(1)
        }
    }
    
    private var name: some View {
        Text(anniversary.name)
            .font(.title3)
            .bold()
    }
    
    private var date: some View {
        Text(anniversary.date.formatted(.anniversaryDate))
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(#color("#aaaaaa"))
    }
    
    private var reminds: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(#localized("Remind")): ")
                .bold()
                .foregroundStyle(#color("#aaaaaa"))
            +
            Text(anniversary.remindDate)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var memo: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(#localized("Memo")): ")
                .bold()
                .foregroundStyle(#color("#aaaaaa"))
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
    
    private func nthTitle(_ title: String) -> some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
            .bold()
            .foregroundStyle(#color("#aaaaaa"))
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
