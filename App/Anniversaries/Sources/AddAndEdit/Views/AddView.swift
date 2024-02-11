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
    
    @Bindable private var store: StoreOf<AddAndEdit>
    
    public var body: some View {
        NavigationView {
            AddAndEditContentView(store: store)
                .navigationTitle(#localized("New"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(#localized("Cancel")) {
                            store.send(.cancelButtonTapped)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(#localized("Add")) {
                            store.send(.addButtonTapped)
                        }
                        .disabled(store.isAddButtonDisabled)
                    }
                }
                .sheet(
                    item: $store.scope(state: \.destination?.remind, action: \.destination.remind),
                    content: RemindSchedulerView.init(store:)
                )
                .alert(
                    $store.scope(state: \.destination?.alert, action: \.destination.alert)
                )
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(store: .init(initialState: .init(mode: .add), reducer: AddAndEdit.init))
            .previewDisplayName("Add")
    }
}
