//
//  Created by マハルジャン ビニシュ on 2024/02/11.
//

import Foundation
import AddAndEdit
import ComposableArchitecture
import CoreKit
import SwiftDataClient
import WidgetCenterClient
import AppUI

@Reducer
public struct Detail {
    @Reducer(state: .equatable)
    public enum Destination {
        case edit(AddAndEdit)
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable {
            case onDismissed
        }
    }
    
    @ObservableState @dynamicMemberLookup
    public struct State: Equatable {
        public init(anniversary: Anniversary) {
            self.anniversary = anniversary
        }
        
        public subscript<T>(dynamicMember keyPath: KeyPath<Anniversary, T>) -> T {
            return anniversary[keyPath: keyPath]
        }
        
        @Presents var destination: Destination.State?
        
        var anniversary: Anniversary
    }
    
    @CasePathable
    public enum Action {
        @CasePathable
        public enum Delegate {
            case deleteAnniversarySuccessful
        }
        
        case destination(PresentationAction<Destination.Action>)
        case editButtonTapped
        case deleteButtonTapped
        case deleteAnniversary(Result<Void, Error>)
        case delegate(Delegate)
    }
    
    public init() { }
    
    @Dependency(\.anniversaryDataClient) private var anniversaryDataClient
    @Dependency(\.widgetCenterClient) private var widgetCenterClient
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .editButtonTapped:
                state.destination = .edit(.init(mode: .edit(state.anniversary)))
                
            case .deleteButtonTapped:
                return .run { [anniversary = state.anniversary] send in
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
                widgetCenterClient.reloadAllTimelines()
                return .run { send in
                    await send(.delegate(.deleteAnniversarySuccessful))
                    await dismiss()
                }
                
            case .deleteAnniversary(.failure):
                state.destination = .alert(
                    AlertState {
                        TextState(#localized("Failed to delete anniversary"))
                    } actions: {
                        ButtonState(action: .onDismissed) { TextState(#localized("OK")) }
                    }
                )

            case .destination(.presented(.edit(.delegate(.saveAnniversarySuccessful(let anniversary))))):
                state.anniversary = anniversary
                
            case .destination, .delegate:
                break
            }
            
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
