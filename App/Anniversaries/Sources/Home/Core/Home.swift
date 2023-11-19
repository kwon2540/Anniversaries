//
//  Created by Maharjan Binish on 2023/03/05.
//

import AddAndEdit
import AppUI
import ComposableArchitecture
import CoreKit
import Foundation
import SwiftDataClient
import Theme

public struct Home: Reducer {
    public struct State: Equatable {
        public init(themeState: Theme.State) {
            self.themeState = themeState
        }

        @PresentationState var destination: Destination.State?

        var anniversaries: [Anniversary] = []
        var groupedAnniversariesList: [GroupedAnniversaries] = []
        var themeState: Theme.State
        var currentSort: Sort.Kind = .defaultCategory
        var currentSortOrder: Sort.Order = .ascending
    }

    public enum Action: Equatable {
        public enum Delegate: Equatable {
        }

        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case fetchAnniversaries
        case anniversariesResponse(TaskResult<[Anniversary]>)
        case sortAnniversaries
        case editButtonTapped
        case sortByButtonTapped(Sort.Kind)
        case sortOrderButtonTapped(Sort.Order)
        case themeButtonTapped(Theme.Preset)
        case addButtonTapped
        case ItemTapped(Anniversary)
        case delegate(Delegate)
        case themeAction(Theme.Action)
    }

    public init() {}

    @Dependency(\.userDefaultsClient) private var userDefaultClient
    @Dependency(\.anniversaryDataClient) private var anniversaryDataClient

    public var body: some ReducerOf<Self> {
        Scope(state: \.themeState, action: /Action.themeAction) {
            Theme()
        }

        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                state.currentSort = userDefaultClient.currentAnniversariesSort()
                state.currentSortOrder = userDefaultClient.currentAnniversariesSortOrder()

                return .send(.fetchAnniversaries)

            case .fetchAnniversaries:
                return .run { send in
                    await send(
                        .anniversariesResponse(
                            TaskResult {
                                try anniversaryDataClient.fetch()
                            }
                        )
                    )
                }

            case .anniversariesResponse(.success(let anniversaries)):
                state.anniversaries = anniversaries
                return .send(.sortAnniversaries)

            case .anniversariesResponse(.failure(let error)):
                assertionFailure(error.localizedDescription)
                state.destination = .alert(
                    AlertState(title: TextState(#localized("Failed to load data")))
                )

            case .sortAnniversaries:
                let anniversaries = state.anniversaries
                let result: [GroupedAnniversaries]
                switch state.currentSort {
                case .defaultCategory:
                    // AnniversaryKindをKeyでGroupしている
                    var anniversariesDictionary: [AnniversaryKind: [Anniversary]] = Dictionary(
                        grouping: anniversaries,
                        by: { $0.kind }
                    )
                    // anniversariesDictionaryのValueを名前順にソートする
                    anniversariesDictionary.forEach {
                        anniversariesDictionary[$0] = $1.sorted(using: KeyPathComparator(\.name))
                    }
                    // AnniversaryKindのIntのRawValueでソートを行なっている
                    let sortedGroupedAnniversaries = anniversariesDictionary
                        .sorted {
                            $0.key.rawValue < $1.key.rawValue
                        }
                        .map(GroupedAnniversaries.init(element:))
                    result = state.currentSortOrder == .ascending ? sortedGroupedAnniversaries : sortedGroupedAnniversaries.reversed()
                case .date:
                    // Date.FormatStyle.FormatOutput(String)をKeyでGroupしている
                    let anniversariesDictionary: [Date.FormatStyle.FormatOutput: [Anniversary]] = Dictionary(
                        grouping: anniversaries,
                        by: { $0.month }
                    )
                    // Date.FormatStyle.FormatOutput(String)ではソートがうまくできないため、digitsMonthを利用するソートを行なっている
                    let sortedGroupedAnniversaries = anniversariesDictionary
                        .sorted {
                            $0.value.first?.digitsMonth ?? 0 < $1.value.first?.digitsMonth ?? 0
                        }
                        .map(GroupedAnniversaries.init(element:))
                    result = state.currentSortOrder == .ascending ? sortedGroupedAnniversaries : sortedGroupedAnniversaries.reversed()
                case .name:
                    let sortedAnniversaries = anniversaries
                        .sorted(using: KeyPathComparator(\.name, order: state.currentSortOrder == .ascending ? .forward : .reverse))
                    result = [GroupedAnniversaries(key: #localized("Name"), anniversaries: sortedAnniversaries)]
                }
                state.groupedAnniversariesList = result

            case .editButtonTapped:
                break

            case .sortByButtonTapped(let sort):
                state.currentSort = sort
                userDefaultClient.setCurrentAnniversariesSort(sort)
                return .send(.sortAnniversaries)

            case .sortOrderButtonTapped(let sortOrder):
                state.currentSortOrder = sortOrder
                userDefaultClient.setCurrentAnniversariesSortOrder(sortOrder)
                return .send(.sortAnniversaries)

            case .themeButtonTapped(let theme):
                return .send(.themeAction(.presetChanged(theme)))

            case .addButtonTapped:
                state.destination = .add(.init(mode: .add))

            case .ItemTapped(let anniversary):
                state.destination = .edit(.init(mode: .edit(anniversary)))

            case .destination(.presented(.add(.saveAnniversaries(.success)))):
                return .send(.fetchAnniversaries)

            case .themeAction, .destination:
                break
            }
            return .none
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

// MARK: Destination
extension Home {
    public struct Destination: Reducer {
        public enum State: Equatable {
            case add(AddAndEdit.State)
            case edit(AddAndEdit.State)
            case alert(AlertState<Action.Alert>)
        }

        public enum Action: Equatable {
            public enum Alert: Equatable {
            }
            case add(AddAndEdit.Action)
            case edit(AddAndEdit.Action)
            case alert(Alert)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.add, action: /Action.add, child: AddAndEdit.init)
            Scope(state: /State.edit, action: /Action.edit, child: AddAndEdit.init)
        }
    }
}
