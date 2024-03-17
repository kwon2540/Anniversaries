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
        var licenses = LicensePlugin.licenses
    }
    
    public enum Action {
        case closeButtonTapped
    }
    
    public init() { }
    
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .closeButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}
