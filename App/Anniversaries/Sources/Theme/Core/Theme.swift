//
//  Created by Maharjan Binish on 2023/03/19.
//

import AppUI
import ComposableArchitecture
import Foundation
import SwiftUI
import UserDefaultsClient

public struct Theme: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
        public var currentPreset: Preset?
        public var foregroundColor: Color {
            (currentPreset ?? .default).foregroundColor
        }
        public var backgroundColor: Color {
            (currentPreset ?? .default).backgroundColor
        }
    }

    public enum Action: Equatable {
        case onLaunch
        case presetChanged(Preset)
        case onLoaded
    }

    public init() {}

    @Dependency(\.userDefaultsClient) var userDefaultsClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onLaunch:
                state.currentPreset = .init(rawValue: userDefaultsClient.currentTheme()) ?? .default
                return .send(.onLoaded)

            case .presetChanged(let preset):
                state.currentPreset = preset
                userDefaultsClient.setCurrentTheme(preset.rawValue)

            case .onLoaded:
                break
            }

            return .none
        }
    }
}

extension Theme {
    public enum Preset: Int {
        case `default`
        case midnightSky
        case sunriseGlow
        case forestWalk
        case cherryBlossom
        case oceanBreeze

        public var backgroundColor: Color {
            switch self {
            case .default:
                return #color("dark_blue")
            case .midnightSky:
                return #color("dark_blue")
            case .sunriseGlow:
                return #color("orange")
            case .forestWalk:
                return #color("forest_green")
            case .cherryBlossom:
                return #color("soft_red")
            case .oceanBreeze:
                return #color("sky_blue")
            }
        }

        public var foregroundColor: Color {
            switch self {
            case .default:
                return #color("black")
            case .midnightSky:
                return #color("light_gray")
            case .sunriseGlow:
                return #color("dark_blue")
            case .forestWalk:
                return #color("white")
            case .cherryBlossom:
                return #color("light_yellow")
            case .oceanBreeze:
                return #color("white")
            }
        }
    }
}
