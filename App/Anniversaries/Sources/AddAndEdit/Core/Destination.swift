//
//  Created by Maharjan Binish on 2023/07/16.
//

import Foundation
import ComposableArchitecture
import RemindScheduler

public struct Destination: Reducer {
    public enum State: Equatable {
        case remind(RemindScheduler.State)
    }

    public enum Action: Equatable {
        case remind(RemindScheduler.Action)
    }

    public var body: some ReducerOf<Destination> {
        Scope(state: /State.remind, action: /Action.remind) {
            RemindScheduler()
        }
    }
}
