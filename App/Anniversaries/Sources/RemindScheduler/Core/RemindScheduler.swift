//
//  Created by Maharjan Binish on 2023/07/16.
//

import ComposableArchitecture
import Foundation

public struct RemindScheduler: Reducer {
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
