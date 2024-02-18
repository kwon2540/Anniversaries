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
    
    @Bindable private var store: StoreOf<AddAndEdit>
    
    public var body: some View {
        NavigationView {
            AddAndEditContentView(store: store)
                .navigationTitle(#localized("Edit"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(#localized("Cancel")) {
                            store.send(.cancelButtonTapped)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(#localized("Done")) {
                            store.send(.doneButtonTapped)
                        }
                        .disabled(store.isDoneButtonDisabled)
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

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(store: .init(initialState: .init(mode: .edit(.init(id: UUID(), kind: .birth, othersTitle: "", name: "", date: .now, reminds: [], memo: ""))), reducer: AddAndEdit.init))
            .previewDisplayName("Edit")
    }
}
