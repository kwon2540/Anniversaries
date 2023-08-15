//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import ComposableArchitecture
import Foundation
import CoreKit

public struct AddAndEdit: Reducer {
    public struct State: Equatable {
        public enum Mode {
            case new
            case edit
        }

        public enum Kind: CaseIterable {
            case birth
            case marriage
            case death
            case others
        }

        public init(mode: Mode) {
            self.mode = mode
        }

        @PresentationState var destination: Destination.State?
        @BindingState var selectedKind: Kind = .birth
        @BindingState var othersTitle = ""
        @BindingState var name = ""
        @BindingState var date: Date = .now
        @BindingState var memo = ""

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
    }

    public init() {}

    @Dependency(\.dismiss) private var dismiss

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce<State, Action> { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            case .completeButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case .addRemindButtonTapped:
                state.destination = .remind(.init())

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
