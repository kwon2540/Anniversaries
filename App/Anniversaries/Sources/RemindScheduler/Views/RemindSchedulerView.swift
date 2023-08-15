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
    
    private let store: StoreOf<RemindScheduler>
    
    public var body: some View {
        WithViewStore(store, observe:  { $0 }) { viewStore in
            NavigationView {
                Form {
                    Section {
                        // Date Row
                        dateItem(description: viewStore.selectedDate.formatted(.calendarDate)) {
                            viewStore.send(.dateTapped, animation: .default)
                        }
                        
                        // Date Selection Picker
                        if viewStore.isDateExpanded {
                            datePickerItem(selection: viewStore.$selectedDate, startDate: viewStore.startDate)
                        }
                        
                        // Time Row
                        timeItem(
                            isOn: viewStore.$isCustomTime.animation(),
                            isCustomTime: viewStore.isCustomTime,
                            description: viewStore.selectedDate.formatted(.calendarTime)
                        ) {
                            viewStore.send(.timeTapped, animation: .default)
                        }
                        
                        // Time Selection Picker
                        if viewStore.isCustomTime && viewStore.isTimeExpanded {
                            timePickerItem(selection: viewStore.$selectedDate)
                        }
                    }
                    
                    Section {
                        // Repeat Row
                        repeatItem(isOn: viewStore.$isRepeat.animation())
                    } footer: {
                        Text(#localized("If you have enabled the repeat feature, we will send you a reminder on the date you specify each year."))
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
    
    private func datePickerItem(selection: Binding<Date>, startDate: Date) -> some View {
        DatePicker(
            "", selection: selection,
            in: startDate...,
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
            initialState: RemindScheduler.State(),
            reducer: RemindScheduler.init
        )
    )
}
