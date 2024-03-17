//
//  Created by マハルジャン ビニシュ on 2024/03/10.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct License {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action {
        
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}
