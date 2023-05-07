//
//  Created by Maharjan Binish on 2023/03/05.
//

import ComposableArchitecture
import Foundation
import Theme
import Settings

public struct Home: Reducer {
    public struct State: Equatable {
        public init(anniversaries: String, themeState: Theme.State) {
            self.anniversaries = anniversaries
            self.themeState = themeState
        }

        @PresentationState var destination: Destination.State?
        var anniversaries: String
        var themeState: Theme.State
    }

    public enum Action: Equatable {
        public enum Delegate: Equatable {
        }

        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case settingsButtonTapped
        case delegate(Delegate)
        case themeAction(Theme.Action)
    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.themeState, action: /Action.themeAction) {
            Theme()
        }

        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                break

            case .settingsButtonTapped:
                state.destination = .settings(.init())

            case .themeAction:
                break
                
            case .destination:
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
extension Home {
    public struct Destination: Reducer {
        public enum State: Equatable {
            case settings(Settings.State)
        }

        public enum Action: Equatable {
            case settingsAction(Settings.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.settings, action: /Action.settingsAction, child: Settings.init)
        }
    }
}
