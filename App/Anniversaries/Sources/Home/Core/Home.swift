//
//  Created by Maharjan Binish on 2023/03/05.
//

import ComposableArchitecture
import Foundation

public struct Home: ReducerProtocol {
    public struct State: Equatable {
        public init(anniversaries: String) {
            self.anniversaries = anniversaries
        }

        var anniversaries: String
    }

    public enum Action: Equatable {

    }

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
