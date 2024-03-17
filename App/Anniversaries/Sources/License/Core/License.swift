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
        var licenses: [LicensePlugin.License] = []
    }
    
    public enum Action { 
        case onAppear
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                state.licenses = LicensePlugin.licenses
                return .none
            }
        }
    }
}
