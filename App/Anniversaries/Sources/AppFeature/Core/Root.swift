//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import Foundation
import Home
import Theme

public struct Root: Reducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var themeState = Theme.State()

        public init() {
            self.destination = .launch(.init(themeState: themeState))
        }
    }
    
    public enum Action: Equatable {
        case launchAction(Launch.Action)
        case homeAction(Home.Action)

        case destination(PresentationAction<Destination.Action>)
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .destination(.presented(.launchAction(.themeAction(.onLoaded)))):
                if let destination = state.destination, case let .launch(launchState) = destination {
                    state.themeState = launchState.themeState
                }

            case .destination(.presented(.launchAction(.delegate(.onComplete(let anniversaries))))):
                state.destination = .home(.init(anniversaries: anniversaries, themeState: state.themeState))

            case .launchAction, .homeAction, .destination:
                break
            }
            return .none
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

// MARK: Destination
extension Root {
    public struct Destination: Reducer {
        public enum State: Equatable {
            case launch(Launch.State)
            case home(Home.State)
        }

        public enum Action: Equatable {
            case launchAction(Launch.Action)
            case homeAction(Home.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.launch, action: /Action.launchAction) {
                Launch()
            }

            Scope(state: /State.home, action: /Action.homeAction) {
                Home()
            }
        }
    }
}
