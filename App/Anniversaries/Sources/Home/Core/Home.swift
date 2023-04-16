//
//  Created by Maharjan Binish on 2023/03/05.
//

import ComposableArchitecture
import Foundation
import Theme
import Settings

public struct Home: ReducerProtocol {
//    public enum Destination: Equatable {
//        case settings(Settings.State)
//    }

    public struct State: Equatable {
        public init(anniversaries: String, themeState: Theme.State) {
            self.anniversaries = anniversaries
            self.themeState = themeState
        }

        var anniversaries: String
        var themeState: Theme.State
        var settingsState: Settings.State?
        @BindingState var searchText: String = ""
    }

    public enum Action: Equatable, BindableAction {
        public enum Delegate: Equatable {
        }

        case binding(BindingAction<State>)
        case onAppear
        case searchButtonTapped
        case settingsButtonTapped
        case dismissSettings
        case settingsAction(Settings.Action)
        case delegate(Delegate)
        case themeAction(Theme.Action)
    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Scope(state: \.themeState, action: /Action.themeAction) {
            Theme()
        }

        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                break
            case .searchButtonTapped:
                print(state.searchText)
            case .settingsButtonTapped:
                state.settingsState = Settings.State(themeState: state.themeState)
            case .dismissSettings:
                state.settingsState = nil
            case .settingsAction:
                break
            case .themeAction:
                break
            case .binding:
                break
            }
            return .none
        }
        .ifLet(\.settingsState, action: /Action.settingsAction) {
            Settings()
        }
        ._printChanges()
    }
}
