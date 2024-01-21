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
        
        @PresentationState var destination: Destination.State?
        @BindingState var selectedKind: AnniversaryKind = .birth
        @BindingState var othersTitle = ""
        @BindingState var name = ""
        @BindingState var date: Date = .now
        @BindingState var memo = ""
        @BindingState var focusedField: Field? = .name
        
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
            switch selectedKind {
            case .birth, .remembrance:
                return name.isEmpty
                
            case .others:
                return name.isEmpty || othersTitle.isEmpty
            }
        }
        var isDoneButtonDisabled: Bool {
            guard let originalAnniversary else { return true }
            return originalAnniversary == resultAnniversary
        }
    }
    
    public enum Action: BindableAction, Equatable {
        public enum Delegate: Equatable {
            case saveAnniversarySuccessful
        }
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case cancelButtonTapped
        case addButtonTapped
        case doneButtonTapped
        case addRemindButtonTapped
        case deleteRemind(IndexSet)
        case saveAnniversaries(TaskResult<VoidSuccess>)
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
            case .binding(\.$selectedKind) where state.selectedKind == .others:
                state.focusedField = .title
                
            case .cancelButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case .addButtonTapped:
                return .run { [anniversary = state.resultAnniversary] send in
                    await send(
                        .saveAnniversaries(
                            TaskResult {
                                let notificationRequest = createNotificationRequests(for: anniversary)
                                for request in notificationRequest {
                                    try await userNotificationsClient.add(request)
                                }
                                anniversaryDataClient.insert(anniversary)
                                return try anniversaryDataClient.save()
                            }
                        )
                    )
                }
                
            case .doneButtonTapped:
                guard let originalAnniversary = state.originalAnniversary else { break }
                return .run { [anniversary = state.resultAnniversary] send in
                    await send(
                        .saveAnniversaries(
                            TaskResult {
                                let originalRemindIDs = originalAnniversary.reminds.map(\.id.uuidString)
                                await userNotificationsClient.removePendingNotificationRequestsWithIdentifiers(originalRemindIDs)
                                
                                let notificationRequest = createNotificationRequests(for: anniversary)
                                for request in notificationRequest {
                                    try await userNotificationsClient.add(request)
                                }
                                
                                // FIXME: SwiftDataのUpdateがTCAで利用できるようになったら対応する
                                anniversaryDataClient.delete(originalAnniversary)
                                anniversaryDataClient.insert(anniversary)
                                return try anniversaryDataClient.save()
                            }
                        )
                    )
                }
                
            case .addRemindButtonTapped:
                state.destination = .remind(.init(anniversaryDate: state.date))
                
            case .saveAnniversaries(.success):
                return .run { send in
                    await send(.delegate(.saveAnniversarySuccessful))
                    await dismiss()
                }
                
            case .saveAnniversaries(.failure(let error)):
                assertionFailure(error.localizedDescription)
                state.destination = .alert(
                    AlertState(title: TextState(#localized("Failed to save data")))
                )
                
            case .destination(.presented(.remind(.remindApplied(let remind)))):
                state.reminds.append(remind)
                
            case .deleteRemind(let indexSet):
                state.reminds.remove(atOffsets: indexSet)
                
            case .destination, .binding, .delegate:
                break
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
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
