//
//  Created by Maharjan Binish on 2023/03/05.
//

import AddAndEdit
import AppUI
import ComposableArchitecture
import CoreKit
import Foundation
import SwiftDataClient
import UserDefaultsClient

public struct Home: Reducer {
    public struct State: Equatable {
        public init() {}

        @PresentationState var destination: Destination.State?

        var anniversaries: [Anniversary] = []
        var groupedAnniversariesList: [GroupedAnniversaries] = []
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
        case sortAnniversaries
        case editButtonTapped
        case sortByButtonTapped(Sort.Kind)
        case sortOrderButtonTapped(Sort.Order)
        case addButtonTapped
        case ItemTapped(Anniversary)
        case delegate(Delegate)
    }

    public init() {}

    @Dependency(\.userDefaultsClient) private var userDefaultClient
    @Dependency(\.anniversaryDataClient) private var anniversaryDataClient

    public var body: some ReducerOf<Self> {
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
                state.anniversaries = anniversaries
                return .send(.sortAnniversaries)

            case .anniversariesResponse(.failure(let error)):
                assertionFailure(error.localizedDescription)
                state.destination = .alert(
                    AlertState(title: TextState(#localized("Failed to load data")))
                )

            case .sortAnniversaries:
                state.groupedAnniversariesList = state.anniversaries.sorted(by: state.currentSort, order: state.currentSortOrder)

            case .editButtonTapped:
                break

            case .sortByButtonTapped(let sort):
                state.currentSort = sort
                userDefaultClient.setCurrentAnniversariesSort(sort)
                return .send(.sortAnniversaries)

            case .sortOrderButtonTapped(let sortOrder):
                state.currentSortOrder = sortOrder
                userDefaultClient.setCurrentAnniversariesSortOrder(sortOrder)
                return .send(.sortAnniversaries)

            case .addButtonTapped:
                state.destination = .add(.init(mode: .add))

            case .ItemTapped(let anniversary):
                state.destination = .edit(.init(mode: .edit(anniversary)))

            case .destination(.presented(.add(.saveAnniversaries(.success)))):
                return .send(.fetchAnniversaries)

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
            case add(AddAndEdit.State)
            case edit(AddAndEdit.State)
            case alert(AlertState<Action.Alert>)
        }

        public enum Action: Equatable {
            public enum Alert: Equatable {
            }
            case add(AddAndEdit.Action)
            case edit(AddAndEdit.Action)
            case alert(Alert)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.add, action: /Action.add, child: AddAndEdit.init)
            Scope(state: /State.edit, action: /Action.edit, child: AddAndEdit.init)
        }
    }
}
