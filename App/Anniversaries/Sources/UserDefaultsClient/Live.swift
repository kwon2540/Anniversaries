//
//  Created by Maharjan Binish on 2023/03/19.
//

import Foundation
import Dependencies

private enum Keys {
    static let currentTheme = "currentTheme"
}

// - MARK: Dependency (liveValue)
extension UserDefaultsClient: DependencyKey {
    public static let liveValue = Self.live(userDefaults: .standard)
}

// MARK: - Live Implementation
extension UserDefaultsClient {
    public static func live(userDefaults: UserDefaults) -> Self {
        Self(
            currentTheme: {
                userDefaults.integer(forKey: Keys.currentTheme)
            },
            setCurrentTheme: {
                userDefaults.set($0, forKey: Keys.currentTheme)
            }
        )
    }
}
