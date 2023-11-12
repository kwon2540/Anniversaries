//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import AppUI
import ComposableArchitecture
import CoreKit
import Foundation
import SwiftData
import SwiftDataClient

public struct AddAndEdit: Reducer {
    public struct State: Equatable {
        public enum Mode: Equatable {
            case add
            case edit(Anniversary)
        }

        public init(mode: Mode) {
            self.mode = mode
        }

        @PresentationState var destination: Destination.State?
        @BindingState var selectedKind: AnniversaryKind = .birth
        @BindingState var othersTitle = ""
        @BindingState var name = ""
        @BindingState var date: Date = .now
        @BindingState var memo = ""
        var isCompleteButtonDisabled: Bool {
            switch selectedKind {
            case .birth, .remembrance:
                return name.isEmpty

            case .others:
                return name.isEmpty || othersTitle.isEmpty
            }
        }

        var mode: Mode
        var reminds: [Remind] = []
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case cancelButtonTapped
        case completeButtonTapped
        case addRemindButtonTapped
        case deleteRemind(IndexSet)
        case saveAnniversaries(TaskResult<VoidSuccess>)
    }

    public init() {}

    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.anniversaryDataClient) private var anniversaryDataClient
    @Dependency(\.uuid) private var uuid

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce<State, Action> { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            case .completeButtonTapped:
                let anniversary = Anniversary(
                    id: uuid(),
                    kind: state.selectedKind,
                    othersTitle: state.othersTitle,
                    name: state.name,
                    date: state.date,
                    reminds: state.reminds,
                    memo: state.memo
                )
                
                return .run { send in
                    await send(
                        .saveAnniversaries(
                            TaskResult {
                                anniversaryDataClient.insert(anniversary)
                                return try anniversaryDataClient.save()
                            }
                        )
                    )
                }

            case .addRemindButtonTapped:
                state.destination = .remind(.init())

            case .saveAnniversaries(.success):
                return .run { _ in
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

            case .destination, .binding:
                break
            }
            return .none
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}
