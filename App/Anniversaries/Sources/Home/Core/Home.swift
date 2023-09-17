//
//  Created by Maharjan Binish on 2023/03/05.
//

import AddAndEdit
import ComposableArchitecture
import Foundation
import Theme
import CoreKit

public struct Home: Reducer {
    public struct State: Equatable {
        public init(anniversaries: String, themeState: Theme.State) {
            self.anniversaries = anniversaries
            self.themeState = themeState
        }

        @PresentationState var destination: Destination.State?
        var anniversaries: String
        var themeState: Theme.State
        var currentSort: Sort.Kind = .defaultDate
        var currentSortOrder: Sort.Order = .newest
    }

    public enum Action: Equatable {
        public enum Delegate: Equatable {
        }

        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case editButtonTapped
        case sortByButtonTapped(Sort.Kind)
        case sortOrderButtonTapped(Sort.Order)
        case themeButtonTapped(Theme.Preset)
        case addButtonTapped
        case delegate(Delegate)
        case themeAction(Theme.Action)
    }

    public init() {}

    @Dependency(\.userDefaultsClient) private var userDefaultClient
    @Dependency(\.anniversaryDataClient) private var anniversaryDataClient

    public var body: some ReducerOf<Self> {
        Scope(state: \.themeState, action: /Action.themeAction) {
            Theme()
        }

        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                state.currentSort = userDefaultClient.currentAnniversariesSort()
                state.currentSortOrder = userDefaultClient.currentAnniversariesSortOrder()

            case .editButtonTapped:
                break

            case .sortByButtonTapped(let sort):
                // TODO: Perform Sort Logic
                state.currentSort = sort
                userDefaultClient.setCurrentAnniversariesSort(sort)

            case .sortOrderButtonTapped(let sortOrder):
                // TODO: Perform Sort Logic
                state.currentSortOrder = sortOrder
                userDefaultClient.setCurrentAnniversariesSortOrder(sortOrder)

            case .themeButtonTapped(let theme):
                return .send(.themeAction(.presetChanged(theme)))

            case .addButtonTapped:
                state.destination = .anniversary(.init(mode: .new))
                
            case .themeAction, .destination:
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
            case anniversary(AddAndEdit.State)
        }

        public enum Action: Equatable {
            case anniversary(AddAndEdit.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.anniversary, action: /Action.anniversary, child: AddAndEdit.init)
        }
    }
}
