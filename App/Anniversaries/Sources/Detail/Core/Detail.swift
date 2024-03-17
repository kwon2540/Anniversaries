//
//  Created by マハルジャン ビニシュ on 2024/02/11.
//

import Foundation
import AddAndEdit
import ComposableArchitecture
import CoreKit
import SwiftDataClient

@Reducer
public struct Detail {
    @Reducer(state: .equatable)
    public enum Destination {
        case edit(AddAndEdit)
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
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        
        case editButtonTapped
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .editButtonTapped:
                state.destination = .edit(.init(mode: .edit(state.anniversary)))

            case .destination(.presented(.edit(.delegate(.saveAnniversarySuccessful(let anniversary))))):
                state.anniversary = anniversary
                
            case .destination:
                break
            }
            
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
