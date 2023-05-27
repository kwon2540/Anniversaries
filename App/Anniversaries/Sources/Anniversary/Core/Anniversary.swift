//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import ComposableArchitecture
import Foundation
import Core

public struct Anniversary: Reducer {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {
    }

    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}
