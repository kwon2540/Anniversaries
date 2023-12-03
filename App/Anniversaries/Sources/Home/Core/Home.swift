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
import SwiftUI

@Reducer
public struct Home {
    public struct State: Equatable {
        public init() {}

        @PresentationState var destination: Destination.State?
        @BindingState var editMode: EditMode = .inactive

        var anniversaries: [Anniversary] = []
        var groupedAnniversariesList: [GroupedAnniversaries] = []
        var currentSort: Sort.Kind = .defaultCategory
        var currentSortOrder: Sort.Order = .ascending
    }

    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case fetchAnniversaries
        case anniversariesResponse(TaskResult<[Anniversary]>)
        case sortAnniversaries
        case editButtonTapped
        case editDoneButtonTapped
        case sortByButtonTapped(Sort.Kind)
        case sortOrderButtonTapped(Sort.Order)
        case addButtonTapped
        case anniversaryTapped(Anniversary)
        case onDeleteAnniversary(Anniversary)
        case deleteAnniversary(TaskResult<VoidSuccess>)
    }

    public init() {}

    @Dependency(\.userDefaultsClient) private var userDefaultClient
    @Dependency(\.anniversaryDataClient) private var anniversaryDataClient

    public var body: some ReducerOf<Self> {
        BindingReducer()
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
                    AlertState(title: TextState(#localized("Failed to load anniversary")))
                )

            case .sortAnniversaries:
                state.groupedAnniversariesList = state.anniversaries.sorted(by: state.currentSort, order: state.currentSortOrder)

            case .editButtonTapped:
                state.editMode = .active
                
            case .editDoneButtonTapped:
                state.editMode = .inactive

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

            case .anniversaryTapped(let anniversary):
                state.destination = .edit(.init(mode: .edit(anniversary)))
                
            case .onDeleteAnniversary(let anniversary):
                return .run { send in
                    await send(
                        .deleteAnniversary(
                            TaskResult {
                                anniversaryDataClient.delete(anniversary)
                                return try anniversaryDataClient.save()
                            }
                        )
                    )
                }
                
            case .deleteAnniversary(.success):
                return .send(.fetchAnniversaries)
                
            case .deleteAnniversary(.failure):
                state.destination = .alert(
                    AlertState(title: TextState(#localized("Failed to delete anniversary")))
                )      
                return .send(.fetchAnniversaries)

            case .destination(.presented(.add(.delegate(.saveAnniversarySuccessful)))):
                return .send(.fetchAnniversaries)

            case .binding, .destination:
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
    @Reducer
    public struct Destination {
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
