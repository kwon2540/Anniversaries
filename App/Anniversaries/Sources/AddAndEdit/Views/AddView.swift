//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import AppUI
import ComposableArchitecture
import SwiftUI
import RemindScheduler
import CoreKit

public struct AddView: View {
    public init(store: StoreOf<AddAndEdit>) {
        self.store = store
    }

    private var store: StoreOf<AddAndEdit>

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                AddAndEditContentView(viewStore: viewStore)
                    .navigationTitle(#localized("New"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(#localized("Cancel")) {
                                viewStore.send(.cancelButtonTapped)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(#localized("Add")) {
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
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(store: .init(initialState: .init(mode: .add), reducer: AddAndEdit.init))
            .previewDisplayName("Add")
    }
}
