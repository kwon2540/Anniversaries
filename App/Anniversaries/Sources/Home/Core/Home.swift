//
//  Created by Maharjan Binish on 2023/03/05.
//

import ComposableArchitecture
import Foundation
import Theme

public struct Home: ReducerProtocol {
    public struct State: Equatable {
        public init(anniversaries: String, themeState: Theme.State) {
            self.anniversaries = anniversaries
            self.themeState = themeState
        }

        var anniversaries: String
        var themeState: Theme.State
    }

    public enum Action: Equatable {
        case onAppear

        public enum DelegateAction: Equatable {
        }

        case delegate(DelegateAction)
        case themeAction(Theme.Action)
    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.themeState, action: /Action.themeAction) {
            Theme()
        }

        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                break
            case .themeAction:
                break
            }
            return .none
        }
    }
}
