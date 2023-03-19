//
//  Created by Maharjan Binish on 2023/03/19.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import UserDefaultsClient

public struct Theme: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
        public var currentPreset: Preset = .default
    }

    public enum Action: Equatable {
        case onLaunch
        case presetChanged(Preset)
    }

    public init() {}
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onLaunch:
                state.currentPreset = .init(rawValue: userDefaultsClient.currentTheme()) ?? .default

            case .presetChanged(let preset):
                state.currentPreset = preset
                userDefaultsClient.setCurrentTheme(preset.rawValue)
            }

            return .none
        }
    }
}

extension Theme {
    public enum Preset: Int {
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
