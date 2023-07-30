//
//  Created by Maharjan Binish on 2023/07/16.
//

import ComposableArchitecture
import SwiftUI
import AppUI


/*
 TODO:
 
 Add animation...
 Add Caution Text
 Center icon
 */

public struct RemindSchedulerView: View {
    public init(store: StoreOf<RemindScheduler>) {
        self.store = store
    }

    private let store: StoreOf<RemindScheduler>

    public var body: some View {
        WithViewStore(store, observe:  { $0 }) { viewStore in
            NavigationView {
                Form {
                    Section {
                        Button {
                            viewStore.send(.dateTapped)
                        } label: {
                            Label {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(#localized("Date"))
                                        .foregroundStyle(.black)

                                    Text(viewStore.selectedDate.formatted(.calendarDate))
                                        .font(.caption)
                                        .foregroundColor(Color(uiColor: .link))
                                }
                            } icon: {
                                FormIcon(backgroundColor: "#e74c3c", systemName: "calendar")
                            }
                        }

                        if viewStore.isDateExpanded {
                            DatePicker(
                                "Start Date",
                                selection: viewStore.$selectedDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                        }

                        Toggle(isOn: viewStore.$isCustomTime) {
                            Button {
                                viewStore.send(.timeTapped)
                            } label: {
                                Label {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(#localized("Time"))
                                            .foregroundStyle(.black)

                                        Text(viewStore.selectedDate.formatted(.calendarDate))
                                            .font(.caption)
                                            .foregroundStyle(Color(uiColor: .link))
                                    }
                                } icon: {
                                    FormIcon(backgroundColor: "#007aff", systemName: "clock.fill")
                                }
                            }
                        }

                        if viewStore.isCustomTime && viewStore.isTimeExpanded {
                            DatePicker(
                                "Start Date",
                                selection: viewStore.$selectedDate,
                                displayedComponents: [.hourAndMinute]
                            )
                            .datePickerStyle(.wheel)
                        }
                    }

                    Section {
                        Toggle(isOn: viewStore.$isRepeat) {
                            Label {
                                Text(#localized("Repeat"))
                            } icon: {
                                FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
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
