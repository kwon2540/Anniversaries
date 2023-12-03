//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import Foundation
import Home

@Reducer
public struct Root {
    public struct State: Equatable {
        var homeState = Home.State()

        public init() {
        }
    }
    
    public enum Action: Equatable {
        case homeAction(Home.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .homeAction:
                break
            }
            return .none
        }
        Scope(state: \.homeState, action: \.homeAction, child: Home.init)
    }
}
