//
//  Created by Maharjan Binish on 2023/04/16.
//

import ComposableArchitecture
import Theme

public struct Settings: ReducerProtocol {
    public struct State: Equatable {
        public init(themeState: Theme.State) {
            self.themeState = themeState
        }
        var themeState: Theme.State
    }

    public enum Action: Equatable {
        case themeAction(Theme.Action)
    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
