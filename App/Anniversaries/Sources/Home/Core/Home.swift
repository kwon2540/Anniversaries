//
//  Created by Maharjan Binish on 2023/03/05.
//

import AddAndEdit
import AppUI
import ComposableArchitecture
import CoreKit
import Foundation
import SwiftDataClient
import Theme

public struct Home: Reducer {
    public struct State: Equatable {
        public init(themeState: Theme.State) {
            self.themeState = themeState
        }

        @PresentationState var destination: Destination.State?
        var anniversaries: [[Anniversary]] = []
        var themeState: Theme.State
        var currentSort: Sort.Kind = .defaultCategory
        var currentSortOrder: Sort.Order = .ascending
    }

    public enum Action: Equatable {
        public enum Delegate: Equatable {
        }

        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case fetchAnniversaries
        case anniversariesResponse(TaskResult<[Anniversary]>)
        case sortAnniversaries([Anniversary])
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

                return .send(.fetchAnniversaries)

            case .fetchAnniversaries:
                return .run { send in
                    await send(
                        .anniversariesResponse(
                            TaskResult {
                                try anniversaryDataClient.fetch()
                            }
                        )
                    )
                }

            case .anniversariesResponse(.success(let anniversaries)):
                return .send(.sortAnniversaries(anniversaries))

            case .anniversariesResponse(.failure(let error)):
                assertionFailure(error.localizedDescription)
                state.destination = .alert(
                    AlertState(title: TextState(#localized("Failed to load data")))
                )

            case .sortAnniversaries(let anniversaries):
                let result: [[Anniversary]]
                switch state.currentSort {
                case .defaultCategory:
                    var groupedAnniversaries: [[Anniversary]] = []
                    AnniversaryKind.allCases.forEach { kind in
                        groupedAnniversaries.append(anniversaries.filter { $0.kind == kind })
                    }
                    result = groupedAnniversaries
                case .date:
                    var groupedAnniversaries: [[Anniversary]] = []
                    // TODO: 12月分のグループに分けてResultに返す
                    result = groupedAnniversaries
                case .name:
                    var sortedAnniversaries = anniversaries.sorted(using: KeyPathComparator(\.name, order: state.currentSortOrder == .ascending ? .forward : .reverse))
                    result = [sortedAnniversaries]
                }
                state.anniversaries = result

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

            case .destination(.presented(.anniversary(.saveAnniversaries(.success)))):
                return .send(.fetchAnniversaries)

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
            case alert(AlertState<Action.Alert>)
        }

        public enum Action: Equatable {
            public enum Alert: Equatable {
            }
            case anniversary(AddAndEdit.Action)
            case alert(Alert)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.anniversary, action: /Action.anniversary, child: AddAndEdit.init)
        }
    }
}
