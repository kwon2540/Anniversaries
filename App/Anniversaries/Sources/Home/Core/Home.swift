//
//  Created by Maharjan Binish on 2023/03/05.
//

import AddAndEdit
import Detail
import AppUI
import ComposableArchitecture
import CoreKit
import Foundation
import SwiftDataClient
import UserDefaultsClient
import SwiftUI
import License

@Reducer
public struct Home {
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        @Presents var destination: Destination.State?
        var editMode: EditMode = .inactive
        
        var anniversaries: [Anniversary] = []
        var groupedAnniversariesList: [GroupedAnniversaries] = []
        var currentSort: Sort.Kind = .defaultCategory
        var currentSortOrder: Sort.Order = .ascending
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case fetchAnniversaries
        case anniversariesResponse(Result<[Anniversary], Error>)
        case sortAnniversaries
        case editButtonTapped
        case editDoneButtonTapped
        case sortByButtonTapped(Sort.Kind)
        case sortOrderButtonTapped(Sort.Order)
        case addButtonTapped
        case licenseButtonTapped
        case anniversaryTapped(Anniversary)
        case onDeleteAnniversary(Anniversary)
        case deleteAnniversary(Result<Void, Error>)
    }
    
    public init() {}
    
    @Dependency(\.userDefaultsClient) private var userDefaultClient
    @Dependency(\.anniversaryDataClient) private var anniversaryDataClient
    @Dependency(\.continuousClock) private var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear where state.anniversaries.isEmpty:
                state.currentSort = userDefaultClient.currentAnniversariesSort()
                state.currentSortOrder = userDefaultClient.currentAnniversariesSortOrder()
                
                return .send(.fetchAnniversaries)
                
            case .fetchAnniversaries:
                return .run { send in
                    await send(
                        .anniversariesResponse(
                            Result {
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
            
            case .licenseButtonTapped:
                state.destination = .license(.init())
                
            case .anniversaryTapped(let anniversary):
                state.destination = .detail(.init(anniversary: anniversary))
                
            case .onDeleteAnniversary(let anniversary):
                return .run { send in
                    // Wait for delete animation to complete
                    try await clock.sleep(for: .seconds(0.3))
                    await send(
                        .deleteAnniversary(
                            Result {
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
                    AlertState {
                        TextState(#localized("Failed to delete anniversary"))
                    } actions: {
                        ButtonState(action: .onDismissed) { TextState(#localized("OK")) }
                    }
                )
                
            case .destination(.presented(.add(.delegate(.saveAnniversarySuccessful)))),
                    .destination(.presented(.detail(.destination(.presented(.edit(.delegate(.saveAnniversarySuccessful))))))):
                return .send(.fetchAnniversaries)
                
            case .destination(.presented(.alert(.onDismissed))):
                // Clearing grouped anniversary, so that view will re-render
                state.groupedAnniversariesList = []
                return .send(.fetchAnniversaries)
                
            case .binding, .destination, .onAppear:
                break
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination) {
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
            case detail(Detail.State)
            case license(License.State)
            case alert(AlertState<Action.Alert>)
        }
        
        public enum Action {
            public enum Alert: Equatable {
                case onDismissed
            }
            case add(AddAndEdit.Action)
            case detail(Detail.Action)
            case license(License.Action)
            case alert(Alert)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.add, action: \.add, child: AddAndEdit.init)
            Scope(state: \.detail, action: \.detail, child: Detail.init)
            Scope(state: \.license, action: \.license, child: License.init)
        }
    }
}
