//
//  Created by Maharjan Binish on 2023/03/19.
//

import CoreKit
import Foundation
import Dependencies

private enum Keys {
    static let currentTheme = "currentTheme"
    static let currentAnniversariesSort = "currentAnniversariesSort"
    static let currentAnniversariesSortOrder = "currentAnniversariesSortOrder"
}

// - MARK: Dependency (liveValue)
extension UserDefaultsClient: DependencyKey {
    public static let liveValue = Self.live(userDefaults: .standard)
}

// MARK: - Live Implementation
extension UserDefaultsClient {
    public static func live(
        userDefaults: UserDefaults,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        jsonEncoder: JSONEncoder = JSONEncoder()
    ) -> Self {
        Self(
            currentTheme: {
                userDefaults.integer(forKey: Keys.currentTheme)
            },
            setCurrentTheme: {
                userDefaults.set($0, forKey: Keys.currentTheme)
            },
            currentAnniversariesSort: {
                guard let data = userDefaults.data(forKey: Keys.currentAnniversariesSort),
                      let sort = try? jsonDecoder.decode(Sort.Kind.self, from: data) else {
                    return .defaultDate
                }

                return sort
            },
            setCurrentAnniversariesSort: { sort in
                guard let data = try? jsonEncoder.encode(sort) else {
                    assertionFailure("Failed UserDefaults.sort.set")
                    return
                }

                userDefaults.set(data, forKey: Keys.currentAnniversariesSort)
            },
            currentAnniversariesSortOrder: {
                guard let data = userDefaults.data(forKey: Keys.currentAnniversariesSortOrder),
                      let sortOrder = try? jsonDecoder.decode(Sort.Order.self, from: data)  else {
                    return .newest
                }

                return sortOrder
            },
            setCurrentAnniversariesSortOrder: { sortOrder in
                guard let data = try? jsonEncoder.encode(sortOrder) else {
                    assertionFailure("Failed UserDefaults.sortOrder.set")
                    return
                }

                userDefaults.set(data, forKey: Keys.currentAnniversariesSortOrder)
            }
        )
    }
}
