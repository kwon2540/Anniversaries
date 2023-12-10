//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import AppUI
import ComposableArchitecture
import CoreKit
import Foundation
import SwiftData
import SwiftDataClient

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
                self.othersTitle = anniversary.othersTitle ?? ""
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
                                // FIXME: SwiftDataのUpdateがTCAで利用できるようになったら対応する
                                anniversaryDataClient.delete(originalAnniversary)
                                anniversaryDataClient.insert(anniversary)
                                return try anniversaryDataClient.save()
                            }
                        )
                    )
                }

            case .addRemindButtonTapped:
                state.destination = .remind(.init())

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
