//
//  Created by クォン ジュンヒョク on 2023/04/09.
//

import ComposableArchitecture
import Dependencies
import XCTest

@testable import Theme

@MainActor
final class ThemeTests: XCTestCase {

    func testOnLaunch() async {
        let testStore = TestStore(
            initialState: .init(),
            reducer: Theme()
        )

        let currentTheme = Theme.Preset.default

        testStore.dependencies.userDefaultsClient.currentTheme = { currentTheme.rawValue }

        await testStore.send(.onLaunch) {
            $0.currentPreset = currentTheme
        }

        await testStore.receive(.onLoaded)
    }

    func testPresetChanged() async {
        let testStore = TestStore(
            initialState: .init(),
            reducer: Theme()
        )

        let theme = Theme.Preset.midnightSky

        testStore.dependencies.userDefaultsClient.setCurrentTheme = { presetRawValue in
            XCTAssertEqual(theme.rawValue, presetRawValue)
        }

        await testStore.send(.presetChanged(theme)) {
            $0.currentPreset = theme
        }
    }
}
