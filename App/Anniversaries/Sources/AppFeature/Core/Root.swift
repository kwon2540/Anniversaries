//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import Foundation
import Home

// show empty main view after splash
// localize
public struct Root: ReducerProtocol {
    public struct State: Equatable {
        public enum Phase: Equatable {
            case launch(Launch.State)
            case home(Home.State)
        }
        public var phase: Phase =  .launch(.init())
        
        public init() {}
    }
    
    public enum Action {
        public enum PhaseAction: Equatable {
            case launchAction(Launch.Action)
            case homeAction(Home.Action)
        }
        case phaseAction(PhaseAction)
    }
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .phaseAction(.launchAction(.onComplete(let anniversaries))):
                state.phase = .home(.init(anniversaries: anniversaries))
            case .phaseAction(.launchAction):
                break
            case .phaseAction(.homeAction):
                break
            }
            return .none
        }

        Scope(state: \.phase, action: /Action.phaseAction) {
            Reduce { _, _ in return .none }
            .ifCaseLet(/State.Phase.launch, action: /Action.PhaseAction.launchAction) {
                Launch()
            }
            .ifCaseLet(/State.Phase.home, action: /Action.PhaseAction.homeAction) {
                Home()
            }
        }
    }
}
