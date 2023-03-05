//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import Foundation
import Home

//TODO: Complete Localize
public struct Root: ReducerProtocol {
    public enum State: Equatable {
        case launch(Launch.State)
        case home(Home.State)
        
        public init() {
            self = .launch(.init())
        }
    }
    
    public enum Action {
        case launchAction(Launch.Action)
        case homeAction(Home.Action)
    }
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .launchAction(.onComplete(let anniversaries)):
                state = .home(.init(anniversaries: anniversaries))
            case .launchAction, .homeAction:
                break
            }
            return .none
        }
        .ifCaseLet(/State.launch, action: /Action.launchAction) {
            Launch()
        }
        .ifCaseLet(/State.home, action: /Action.homeAction) {
            Home()
        }
    }
}
