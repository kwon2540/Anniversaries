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

        public init(mode: Mode) {
            self.mode = mode
        }

        @PresentationState var destination: Destination.State?
        var mode: Mode
        var reminds: [Remind] = []
    }

    public enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        case cancelButtonTapped
        case completeButtonTapped
        case addRemindButtonTapped
    }

    public init() {}

    @Dependency(\.dismiss) private var dismiss

    public var body: some ReducerOf<Self> {
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

            case .destination:
                break
            }
            return .none
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}
