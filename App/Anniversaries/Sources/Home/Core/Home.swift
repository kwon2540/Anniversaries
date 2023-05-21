//
//  Created by Maharjan Binish on 2023/03/05.
//

import ComposableArchitecture
import Foundation
import Theme
import Core

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
        public enum Sort: Equatable {
            case date
            case created
            case name
        }

        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case editButtonTapped
        case sortByButtonTapped(Sort)
        case themeButtonTapped(Theme.Preset)
        case addButtonTapped
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

            case .editButtonTapped:
                break

            case .sortByButtonTapped(let sort):
                break

            case .themeButtonTapped(let theme):
                return .send(.themeAction(.presetChanged(theme)))

            case .addButtonTapped:
                break
                
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
        }

        public enum Action: Equatable {
        }

        public var body: some ReducerOf<Self> {
            Reduce { state, action in
                return .none
            }
        }
    }
}
