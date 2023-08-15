//
//  Created by Maharjan Binish on 2023/02/26.
//

import ComposableArchitecture
import Foundation
import Theme

public struct Launch: Reducer {
    public struct State: Equatable {
        var themeState: Theme.State
        @PresentationState var alert: AlertState<Action.Alert>?
    }

    public enum Action: Equatable {
        case onAppear
        case fetchAnniversaries
        case anniversariesResponse(TaskResult<String>)

        public enum Alert: Equatable {
            case reloadButtonTapped
        }

        public enum Delegate: Equatable {
            case onComplete(String) // TODO: pass anniversaries as loaded data
        }

        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case themeAction(Theme.Action)
    }

    @Dependency(\.continuousClock) var clock // TODO: delete

    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.themeAction(.onLaunch))
                
            case .fetchAnniversaries:
                return .run { send in
                    try await clock.sleep(for: .seconds(1)) // TODO: delete
                    return await send(.anniversariesResponse(TaskResult { return "TODO" }))
                }

            case .anniversariesResponse(.success(let anniversaries)):
                return .send(.delegate(.onComplete(anniversaries)))

            case .anniversariesResponse(.failure):
                state.alert = AlertState {
                    TextState("Error")
                } actions: {
                    ButtonState(action: .reloadButtonTapped) {
                        TextState("Retry")
                    }
                } message:  {
                    TextState("Couldn't load data.")
                }

            case .alert(.presented(.reloadButtonTapped)):
                state.alert = nil
                return .send(.fetchAnniversaries)

            case .themeAction(.onLoaded):
                return .send(.fetchAnniversaries)

            case .delegate, .themeAction, .alert:
                break
            }

            return .none
        }
        .ifLet(\.$alert, action: /Action.alert)

        Scope(state: \.themeState, action: /Action.themeAction) {
            Theme()
        }
    }
}
