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
                return Color("dark_blue") // Color.white// Asset.Colors.white.swiftUIColor
            case .midnightSky:
                return Color.blue//Asset.Colors.darkBlue.swiftUIColor
            case .sunriseGlow:
                return Color.orange//Asset.Colors.orange.swiftUIColor
            case .forestWalk:
                return Color.white//Asset.Colors.forestGreen.swiftUIColor
            case .cherryBlossom:
                return Color.white//Asset.Colors.softRed.swiftUIColor
            case .oceanBreeze:
                return Color.white//Asset.Colors.skyBlue.swiftUIColor
            }
        }

        public var foregroundColor: Color {
            switch self {
            case .default:
                return Color.white//Asset.Colors.black.swiftUIColor
            case .midnightSky:
                return Color.white//Asset.Colors.lightGray.swiftUIColor
            case .sunriseGlow:
                return Color.white//Asset.Colors.darkBlue.swiftUIColor
            case .forestWalk:
                return Color.white//Asset.Colors.white.swiftUIColor
            case .cherryBlossom:
                return Color.white//Asset.Colors.lightYellow.swiftUIColor
            case .oceanBreeze:
                return Color.white//Asset.Colors.white.swiftUIColor
            }
        }
    }
}
