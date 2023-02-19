//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import Foundation

public struct Root: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            @unknown default:
                break
            }
            return .none
        }
    }
}
