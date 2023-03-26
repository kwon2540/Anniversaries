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
        public var theme: Theme.Preset = .default
    }

    public enum Action: Equatable {
        public enum ViewAction: Equatable {
            case onAppear
        }

        public enum InnerAction: Equatable {
        }

        public enum DelegateAction: Equatable {
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case themeAction(Theme.Action)
    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            return .none
        }

        Scope(state: \.themeState, action: /Action.themeAction) {
            Theme()
        }
    }
}
