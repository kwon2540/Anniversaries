//
//  Created by Maharjan Binish on 2023/07/16.
//

import ComposableArchitecture
import Foundation
import CoreKit

public struct RemindScheduler: Reducer {
    public struct State: Equatable {
        @BindingState var selectedDate: Date = .now
        @BindingState var isRepeat = true
        @BindingState var isCustomTime = false

        var isDateExpanded = true
        var isTimeExpanded = false

        public init() {}
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case cancelButtonTapped
        case applyButtonTapped
        case dateTapped
        case timeTapped

        case remindApplied(Remind)
    }

    public init() {}

    @Dependency(\.dismiss) private var dismiss

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce<State, Action> { state, action in
            switch action {
            case .binding(\.$isCustomTime):
                state.isTimeExpanded = state.isCustomTime

            case .cancelButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case .applyButtonTapped:
                return .run { [state] send in
                    let remind = Remind(date: state.selectedDate, isRepeat: state.isRepeat)
                    await send(.remindApplied(remind))
                }

            case .remindApplied:
                return .run { _ in
                    await dismiss()
                }

            case .dateTapped:
                state.isDateExpanded.toggle()

            case .timeTapped:
                state.isTimeExpanded.toggle()

            case .binding:
                break
            }
            return .none
        }
    }
}
