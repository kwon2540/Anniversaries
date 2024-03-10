//
//  Created by Maharjan Binish on 2023/07/16.
//

import ComposableArchitecture
import Foundation
import CoreKit

@Reducer
public struct RemindScheduler {
    @ObservableState
    public struct State: Equatable {
        public enum Mode: Equatable {
            case add
            case edit
        }

        public init(anniversaryDate: Date) {
            self.selectedDate = anniversaryDate.nearestFutureDate
            self.mode = .add
        }
        
        public init(remind: Remind) {
            self.selectedDate = remind.date
            self.isRepeat = remind.isRepeat
            self.isCustomTime = true
            self.mode = .edit
        }
        var selectedDate: Date
        var isRepeat = true
        var isCustomTime = false

        var isDateExpanded = true
        var isTimeExpanded = false
        var mode: Mode
        
        var isEditMode: Bool { mode == .edit }
    }

    public enum Action: BindableAction {
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
            case .binding(\.isCustomTime):
                if !state.isCustomTime {
                    state.selectedDate = Calendar.current.startOfDay(for: state.selectedDate)
                }
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
