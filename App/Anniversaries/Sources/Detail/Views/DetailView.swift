//
//  Created by マハルジャン ビニシュ on 2024/02/11.
//

import SwiftUI
import AddAndEdit
import ComposableArchitecture
import CoreKit
import AppUI

public struct DetailView: View {
    public init(store: StoreOf<Detail>) {
        self.store = store
    }

    @Bindable private var store: StoreOf<Detail>

    public var body: some View {
        List {
            Section { 
                LabeledContent(#localized("Kind")) {
                    Text(store.kind.title)
                }
                if case .others = store.kind {
                    LabeledContent(#localized("Title")) {
                        Text(store.othersTitle)
                    }
                }
            }
            Section {
                LabeledContent(#localized("Name")) {
                    Text(store.name)
                }
                LabeledContent(#localized("Date")) {
                    Text(store.date.formatted(.anniversaryDate))
                }
            }
            if store.reminds.count > 0 {
                Section {
                    Text("Remind")
                    ForEach(store.reminds, id: \.self) { remind in
                        HStack {
                            if remind.isRepeat {
                                Text(remind.date.formatted(.remindDateNoYear))
                            } else {
                                Text(remind.date.formatted(.remindDate))
                            }

                            Spacer()
                            
                            if remind.isRepeat {
                                TagView(type: .repeat)
                            }
                        }
                    }
                }
            }
            if !store.memo.isEmpty {
                Section {
                    Text(store.memo)
                }
            }
            
            Section {
                Button(role: .destructive) {
                    store.send(.deleteButtonTapped)
                } label: {
                    Text(#localized("Delete"))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding(.top, -16)
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(#localized("Edit")) {
                    store.send(.editButtonTapped)
                }
            }
        }
        .sheet(
            item: $store.scope(state: \.destination?.edit, action: \.destination.edit),
            content: EditView.init
        )
    }
}

#Preview {
    DetailView(
        store: .init(
            initialState: .init(anniversary: .init(id: UUID(), kind: .birth, othersTitle: "", name: "", date: .now, reminds: [], memo: "")),
            reducer: Detail.init
        )
    )
}
