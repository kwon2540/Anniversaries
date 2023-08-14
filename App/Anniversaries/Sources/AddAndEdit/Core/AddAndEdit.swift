//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import ComposableArchitecture
import Foundation
import CoreKit

public enum AnniversaryKind {
    case birth
    case marriage
    case death
    case other
}

public struct AddAndEdit: Reducer {
    public struct State: Equatable {
        public enum Mode {
            case new
            case edit
        }

        public init(mode: Mode) {
            self.mode = mode
        }

        @PresentationState var destination: Destination.State?
        @BindingState var selectedKind: AnniversaryKind = .birth
        @BindingState var date: Date = .now
        
        var mode: Mode
        var reminds: [Remind] = []
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case cancelButtonTapped
        case completeButtonTapped
        case addRemindButtonTapped
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
