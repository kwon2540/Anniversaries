//
//  Created by クォン ジュンヒョク on 2023/11/12.
//

import AppUI
import ComposableArchitecture
import SwiftUI
import RemindScheduler
import CoreKit

public struct EditView: View {
    public init(store: StoreOf<AddAndEdit>) {
        self.store = store
    }

    private var store: StoreOf<AddAndEdit>

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            AddAndEditContentView(viewStore: viewStore)
                .navigationTitle(#localized("Edit"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(#localized("Done")) {
                            viewStore.send(.completeButtonTapped)
                        }
                        .disabled(viewStore.isCompleteButtonDisabled)
                    }
                }
                .sheet(
                    store: store.scope(state: \.$destination, action: AddAndEdit.Action.destination),
                    state: /Destination.State.remind,
                    action: Destination.Action.remind,
                    content: RemindSchedulerView.init(store:)
                )
                .alert(
                    store: store.scope(state: \.$destination, action: AddAndEdit.Action.destination),
                    state: /Destination.State.alert,
                    action: Destination.Action.alert
                )
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(store: .init(initialState: .init(mode: .edit(.init(id: UUID(), kind: .birth, othersTitle: "", name: "", date: .now, reminds: [], memo: ""))), reducer: AddAndEdit.init))
            .previewDisplayName("Edit")
    }
}
