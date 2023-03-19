//
//  Created by Maharjan Binish on 2023/03/19.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public struct Theme: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
        public var currentPreset: Preset = .default
    }

    public enum Action: Equatable {
        case presetChanged(Preset)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .presetChanged(let preset):
                state.currentPreset = preset
                return .none
            }
        }
    }
}

extension Theme {
    public enum Preset {
        case `default`

        public var backgroundColor: Color {
            switch self {
            case .default: return .white
            }
        }

        public var foregroundColor: Color {
            switch self {
            case .default: return .black
            }
        }
    }
}
