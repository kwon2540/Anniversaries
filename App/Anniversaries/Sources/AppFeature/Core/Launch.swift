//
//  Created by Maharjan Binish on 2023/02/26.
//

import ComposableArchitecture
import Foundation
import Theme

public struct Launch: ReducerProtocol {
    public struct State: Equatable {
        var themeState: Theme.State
        var alertState: AlertState<Action.AlertAction>?
    }

    public enum Action: Equatable {
            case onAppear
            case fetchAnniversaries
            case anniversariesResponse(TaskResult<String>)

        public enum AlertAction: Equatable {
            case onReload
            case onDismiss
        }

        public enum DelegateAction: Equatable {
            case onComplete(String) // TODO: pass anniversaries as loaded data
        }

        case alert(AlertAction)
        case delegate(DelegateAction)
        case themeAction(Theme.Action)
    }

    @Dependency(\.continuousClock) var clock // TODO: delete

    public var body: some ReducerProtocol<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .init(value: .themeAction(.onLaunch))
                
            case .fetchAnniversaries:
                return .task {
                    try await clock.sleep(for: .seconds(1)) // TODO: delete
                    return await .anniversariesResponse(TaskResult { return "TODO" })
                }

            case .anniversariesResponse(.success(let anniversaries)):
                return .init(value: .delegate(.onComplete(anniversaries)))

            case .anniversariesResponse(.failure):
                state.alertState = .init(
                    title: TextState("Error"),
                    message: TextState("Couldn't load data."),
                    buttons: [.cancel(TextState("Retry"), action: .send(.onReload))]
                )

            case .alert(.onReload):
                state.alertState = nil
                return .init(value: .fetchAnniversaries)

            case .alert(.onDismiss):
                state.alertState = nil

            case .themeAction(.onLoaded):
                return .init(value: .fetchAnniversaries)

            case .delegate, .themeAction:
                break
            }

            return .none
        }

        Scope(state: \.themeState, action: /Action.themeAction) {
            Theme()
        }
    }
}
