//
//  Created by Maharjan Binish on 2023/07/16.
//

import ComposableArchitecture
import Foundation

public struct RemindScheduler: Reducer {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {
        case cancelButtonTapped
        case applyButtonTapped
    }

    public init() {}

    @Dependency(\.dismiss) private var dismiss

    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case .applyButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}
