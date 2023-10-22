//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import Foundation
import Home

public struct Root: Reducer {
    public struct State: Equatable {
        var launchState: Launch.State?
        var homeState: Home.State?
        
        public init() {
            self.launchState = .init()
        }
    }
    
    public enum Action: Equatable {
        case launchAction(Launch.Action)
        case homeAction(Home.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .launchAction(.delegate(.onComplete)):
                state.homeState = .init()
                state.launchState = nil

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
