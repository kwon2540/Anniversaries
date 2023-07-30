//
//  Created by Maharjan Binish on 2023/07/16.
//

import ComposableArchitecture
import SwiftUI
import AppUI

public struct RemindSchedulerView: View {
    public init(store: StoreOf<RemindScheduler>) {
        self.store = store
    }

    private let store: StoreOf<RemindScheduler>

    @State private var isRepeat: Bool = true

    public var body: some View {
        WithViewStore(store, observe:  { $0 }) { viewStore in
            NavigationView {
                VStack {
                    Form {
                        Section {

                        }

                        Section {
                            Toggle(isOn: $isRepeat) {
                                Label {
                                    Text(#localized("Repeat"))
                                } icon: {
                                    FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
                                }
                            }
                        }
                    }
                }
                .navigationTitle(#localized("Date & Time"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            viewStore.send(.cancelButtonTapped)
                        } label: {
                            Text(#localized("Cancel"))
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewStore.send(.applyButtonTapped)
                        } label: {
                            Text(#localized("Apply"))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RemindSchedulerView(
        store: Store(
            initialState: RemindScheduler.State(),
            reducer: RemindScheduler.init
        )
    )
}
