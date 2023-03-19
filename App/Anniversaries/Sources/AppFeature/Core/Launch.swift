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
        public enum ViewAction: Equatable {
            case onAppear
        }

        public enum InnerAction: Equatable {
            case fetchAnniversaries
            case anniversariesResponse(TaskResult<String>)
        }

        public enum AlertAction: Equatable {
            case onReload
            case onDismiss
        }

        public enum DelegateAction: Equatable {
            case onComplete(String) // TODO: pass anniversaries as loaded data
        }

        case view(ViewAction)
        case inner(InnerAction)
        case alert(AlertAction)
        case delegate(DelegateAction)
    }

    @Dependency(\.continuousClock) var clock // TODO: delete

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .init(value: .inner(.fetchAnniversaries))

            case .inner(.fetchAnniversaries):
                return .task {
                    try await clock.sleep(for: .seconds(3)) // TODO: delete
                    return await .inner(.anniversariesResponse(TaskResult { return "TODO" }))
                }

            case .inner(.anniversariesResponse(.success(let anniversaries))):
                return .init(value: .delegate(.onComplete(anniversaries)))

            case .inner(.anniversariesResponse(.failure)):
                state.alertState = .init(
                    title: TextState("Error"),
                    message: TextState("Couldn't load data."),
                    buttons: [.cancel(TextState("Retry"), action: .send(.onReload))]
                )

            case .alert(.onReload):
                state.alertState = nil
                return .init(value: .inner(.fetchAnniversaries))

            case .alert(.onDismiss):
                state.alertState = nil
                
            case .delegate:
                break
            }

            return .none
        }
    }
}
