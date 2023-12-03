//
//  Created by Maharjan Binish on 2023/07/16.
//

import Foundation
import ComposableArchitecture
import RemindScheduler

@Reducer
public struct Destination {
    public enum State: Equatable {
        case remind(RemindScheduler.State)
        case alert(AlertState<Action.Alert>)
    }

    public enum Action: Equatable {
        public enum Alert: Equatable {
        }
        case alert(Alert)
        case remind(RemindScheduler.Action)
    }

    public var body: some ReducerOf<Destination> {
        Scope(state: \.remind, action: \.remind) {
            RemindScheduler()
        }
    }
}
