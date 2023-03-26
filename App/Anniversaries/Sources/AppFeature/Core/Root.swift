//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import Foundation
import Home

public struct Root: ReducerProtocol {
    public struct State: Equatable {
        var launchState: Launch.State?
        var homeState: Home.State?
        
        public init() {
            self.launchState = .init(themeState: themeState)
        }
    }
    
    public enum Action: Equatable {
        case launchAction(Launch.Action)
        case homeAction(Home.Action)
    }
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .launchAction(.delegate(.onComplete(let anniversaries))):
                state.homeState = .init(anniversaries: anniversaries, themeState: state.themeState)

            case .launchAction, .homeAction:
                break
            }
            return .none
        }
        .ifLet(\.launchState, action: /Action.launchAction) {
            Launch()
        }
        .ifLet(\.homeState, action: /Action.homeAction) {
            Home()
        }
    }
}
