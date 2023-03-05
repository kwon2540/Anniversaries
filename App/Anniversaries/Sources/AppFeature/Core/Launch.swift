//
//  Created by Maharjan Binish on 2023/02/26.
//

import ComposableArchitecture
import Foundation

public struct Launch: ReducerProtocol {
    public struct State: Equatable {
        var alertState: AlertState<Action.AlertAction>?
    }

    public enum Action: Equatable {
        public enum AlertAction: Equatable {
            case onReload
            case onDismiss
        }
        case onAppear
        case fetchAnniversaries
        case anniversariesResponse(TaskResult<String>)
        case alertAction(AlertAction)
        case onComplete(String) // TODO: pass anniversaries as loaded data
    }

    @Dependency(\.continuousClock) var clock // TODO: delete

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .init(value: .fetchAnniversaries)

            case .fetchAnniversaries:
                return .task {
                    try await clock.sleep(for: .seconds(3)) // TODO: delete
                    return await .anniversariesResponse(TaskResult { return "TODO" })
                }

            case .anniversariesResponse(.success(let anniversaries)):
                return .init(value: .onComplete(anniversaries))

            case .anniversariesResponse(.failure):
                state.alertState = .init(
                    title: TextState("Error"),
                    message: TextState("Couldn't load data."),
                    buttons: [.cancel(TextState("Retry"), action: .send(.onReload))]
                )

            case .alertAction(.onReload):
                state.alertState = nil
                return .init(value: .fetchAnniversaries)

            case .alertAction(.onDismiss):
                state.alertState = nil

            case .onComplete:
                break // Transition to next screen. Process in the parent reducer.
            }
            return .none
        }
    }
}
