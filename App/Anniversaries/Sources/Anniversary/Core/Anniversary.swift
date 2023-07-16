//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import ComposableArchitecture
import Foundation

public struct Anniversary: Reducer {
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
                return .fireAndForget {
                    await dismiss()
                }
            case .completeButtonTapped:
                return .fireAndForget {
                    await dismiss()
                }

            case .addRemindButtonTapped:
                state.destination = .remind(.init())

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
