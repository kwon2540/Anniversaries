//
//  Created by Maharjan Binish on 2023/05/07.
//

import ComposableArchitecture
import Foundation

public struct Settings: Reducer {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {

    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
