//
//  Created by Maharjan Binish on 2023/07/16.
//

import ComposableArchitecture
import SwiftUI
import AppUI
import CoreKit

public struct RemindSchedulerView: View {
    public init(store: StoreOf<RemindScheduler>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<RemindScheduler>
    
    public var body: some View {
        NavigationView {
            Form {
                Section {
                    // Date Row
                    dateItem(description: store.selectedDate.formatted(.calendarDate)) {
                        store.send(.dateTapped, animation: .default)
                    }
                    
                    // Date Selection Picker
                    if store.isDateExpanded {
                        datePickerItem(selection: $store.selectedDate)
                    }
                    
                    // Time Row
                    timeItem(
                        isOn: $store.isCustomTime.animation(),
                        isCustomTime: store.isCustomTime,
                        description: store.selectedDate.formatted(.calendarTime)
                    ) {
                        store.send(.timeTapped, animation: .default)
                    }
                    
                    // Time Selection Picker
                    if store.isCustomTime && store.isTimeExpanded {
                        timePickerItem(selection: $store.selectedDate)
                    }
                }
                
                Section {
                    // Repeat Row
                    repeatItem(isOn: $store.isRepeat.animation())
                } footer: {
                    Text(#localized("If you have enabled the repeat feature, we will send you a reminder on the date you specify each year."))
                }
            }
            .navigationTitle(#localized("Date & Time"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.send(.cancelButtonTapped)
                    } label: {
                        Text(#localized("Cancel"))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.applyButtonTapped)
                    } label: {
                        Text(#localized("Apply"))
                    }
                }
            }
        }
    }
    
    private func dateItem(description: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                FormIcon(backgroundColor: "#e74c3c", systemName: "calendar")
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(#localized("Date"))
                        .foregroundStyle(.black)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Color(uiColor: .link))
                }
            }
        }
    }
    
    private func datePickerItem(selection: Binding<Date>) -> some View {
        DatePicker(
            "", selection: selection,
            in: Calendar.current.startOfDay(for: .now)...,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
    }
    
    private func timeItem(isOn: Binding<Bool>, isCustomTime: Bool, description: String, action: @escaping () -> Void) -> some View {
        Toggle(isOn: isOn) {
            Button(action: action) {
                HStack(spacing: 16) {
                    FormIcon(backgroundColor: "#007aff", systemName: "clock.fill")
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(#localized("Time"))
                            .foregroundStyle(.black)
                        if isCustomTime {
                            Text(description)
                                .font(.caption)
                                .foregroundStyle(Color(uiColor: .link))
                        }
                    }
                }
            }
        }
    }
    
    private func timePickerItem(selection: Binding<Date>) -> some View {
        DatePicker(
            "",
            selection: selection,
            displayedComponents: [.hourAndMinute]
        )
        .datePickerStyle(.wheel)
    }
    
    private func repeatItem(isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            HStack(spacing: 16) {
                FormIcon(backgroundColor: "#c5c5c7", systemName: "repeat")
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(#localized("Repeat"))
                }
            }
        }
    }
}

#Preview {
    RemindSchedulerView(
        store: Store(
            initialState: RemindScheduler.State(anniversaryDate: .now),
            reducer: RemindScheduler.init
        )
    )
}
