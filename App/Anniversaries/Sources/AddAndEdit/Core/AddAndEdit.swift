//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import AppUI
import ComposableArchitecture
import CoreKit
import Foundation
import SwiftData
import SwiftDataClient
import UserNotificationClient
import UserNotifications
import RemindScheduler

@Reducer
public struct AddAndEdit {
    @Reducer(state: .equatable)
    public enum Destination {
        case remind(RemindScheduler)
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }

    @ObservableState
    public struct State: Equatable {
        public enum Mode: Equatable {
            case add
            case edit(Anniversary)
        }
        
        public enum Field: String {
            case title
            case name
        }
        
        public init(mode: Mode) {
            self.mode = mode
            if case let .edit(anniversary) = mode {
                self.originalAnniversary = anniversary
                self.selectedKind = anniversary.kind
                self.othersTitle = anniversary.othersTitle
                self.name = anniversary.name
                self.date = anniversary.date
                self.reminds = anniversary.reminds
                self.memo = anniversary.memo
            }
        }
        
        @Presents var destination: Destination.State?
        var selectedKind: AnniversaryKind = .birth
        var othersTitle = ""
        var name = ""
        var date: Date = Calendar.current.startOfDay(for: .now)
        var memo = ""
        var focusedField: Field? = .name
        
        var mode: Mode
        var reminds: [Remind] = []
        var originalAnniversary: Anniversary? = nil
        
        var resultAnniversary: Anniversary {
            Anniversary(
                id: originalAnniversary?.id ?? UUID(),
                kind: selectedKind,
                othersTitle: othersTitle,
                name: name,
                date: date,
                reminds: reminds,
                memo: memo
            )
        }
        var isAddButtonDisabled: Bool {
            return switch selectedKind {
            case .birth, .remembrance:
                name.isEmpty
            case .others:
                name.isEmpty || othersTitle.isEmpty
            }
        }
        var isDoneButtonDisabled: Bool {
            guard let originalAnniversary else { return true }
            
            return switch selectedKind {
            case .birth, .remembrance:
                name.isEmpty || (originalAnniversary == resultAnniversary)
            case .others:
                name.isEmpty || othersTitle.isEmpty || (originalAnniversary == resultAnniversary)
            }
        }
    }
    
    public enum Action: BindableAction {
        @CasePathable
        public enum Delegate {
            case saveAnniversarySuccessful(Anniversary)
        }
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case cancelButtonTapped
        case addButtonTapped
        case doneButtonTapped
        case addRemindButtonTapped
        case remindTapped(Remind)
        case deleteRemind(IndexSet)
        case saveAnniversaries(Result<Anniversary, Error>)
        case delegate(Delegate)
    }
    
    public init() {}
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.anniversaryDataClient) private var anniversaryDataClient
    @Dependency(\.uuid) private var uuid
    @Dependency(\.userNotificationsClient) private var userNotificationsClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding(\.selectedKind) where state.selectedKind == .others:
                state.focusedField = .title
                
            case .cancelButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .addButtonTapped:
                return .run { [anniversary = state.resultAnniversary] send in
                    await send(
                        .saveAnniversaries(
                            Result {
                                let notificationRequest = createNotificationRequests(for: anniversary)
                                for request in notificationRequest {
                                    try await userNotificationsClient.add(request)
                                }
                                anniversaryDataClient.insert(anniversary)
                                try anniversaryDataClient.save()
                                return anniversary
                            }
                        )
                    )
                }
                
            case .doneButtonTapped:
                guard let originalAnniversary = state.originalAnniversary else { break }
                return .run { [anniversary = state.resultAnniversary] send in
                    await send(
                        .saveAnniversaries(
                            Result {
                                let originalRemindIDs = originalAnniversary.reminds.map(\.id.uuidString)
                                await userNotificationsClient.removePendingNotificationRequestsWithIdentifiers(originalRemindIDs)
                                
                                let notificationRequest = createNotificationRequests(for: anniversary)
                                for request in notificationRequest {
                                    try await userNotificationsClient.add(request)
                                }
                                
                                // FIXME: SwiftDataのUpdateがTCAで利用できるようになったら対応する
                                anniversaryDataClient.delete(originalAnniversary)
                                anniversaryDataClient.insert(anniversary)
                                try anniversaryDataClient.save()
                                return anniversary
                            }
                        )
                    )
                }
                
            case .addRemindButtonTapped:
                state.destination = .remind(.init(anniversaryDate: state.date))
                
            case .remindTapped(let remind):
                state.destination = .remind(.init(remind: remind))
                
            case .saveAnniversaries(.success(let anniversary)):
                return .run { send in
                    await send(.delegate(.saveAnniversarySuccessful(anniversary)))
                    await dismiss()
                }
                
            case .saveAnniversaries(.failure):
                state.destination = .alert(
                    AlertState(title: TextState(#localized("Failed to save data")))
                )
                
            case .destination(.presented(.remind(.delegate(.remindApplied(let remind))))):
                state.reminds.append(remind)
                
            case .destination(.presented(.remind(.delegate(.remindEdited(let remind))))):
                let index = state.reminds.firstIndex { $0.id == remind.id }
                guard let index else {
                    break
                }
                state.reminds[index] = remind
                
            case .deleteRemind(let indexSet):
                state.reminds.remove(atOffsets: indexSet)
                
            case .destination, .binding, .delegate:
                break
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: UserNotifications
extension AddAndEdit {
    private func createNotificationRequests(for anniversary: Anniversary) -> [UNNotificationRequest] {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = #localized("\(anniversary.name)`s \(anniversary.kind.title)")
        
        // Multiple Remind
        return anniversary.reminds.map { remind -> UNNotificationRequest in
            let targetDate = anniversary.date.nearestFutureDate
            let timeRemaining = targetDate.timeIntervalSince(remind.date)
            // Converting timeInterval to Days/Hour/Minute Remaining.
            let dateFormatter = DateComponentsFormatter()
            dateFormatter.unitsStyle = .short
            dateFormatter.allowedUnits = [.day, .hour, .minute]
            dateFormatter.includesTimeRemainingPhrase = true
            
            let daysRemaining = dateFormatter.string(from: timeRemaining) ?? ""
            
            notificationContent.body = #localized("\(anniversary.date.formatted(date: .abbreviated, time: .omitted)) (\(daysRemaining))")
            // Specifying the units for notification trigger
            let components = Calendar.current.dateComponents(
                [.calendar, .year, .month, .day, .hour, .minute],
                from: remind.date
            )
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: remind.isRepeat
            )
            return .init(
                identifier: remind.id.uuidString,
                content: notificationContent,
                trigger: trigger
            )
        }
    }
}
