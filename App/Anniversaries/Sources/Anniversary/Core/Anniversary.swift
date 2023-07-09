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

        var mode: Mode
    }

    public enum Action: Equatable {
        case cancelButtonTapped
        case completeButtonTapped
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
            }
            return .none
        }
    }
}
