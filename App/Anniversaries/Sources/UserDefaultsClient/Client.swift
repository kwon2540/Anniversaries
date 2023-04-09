//
//  Created by Maharjan Binish on 2023/03/19.
//

import Foundation
import Dependencies

public struct UserDefaultsClient {
    public var currentTheme: () -> Int
    public var setCurrentTheme: (Int) -> Void
}

extension DependencyValues {
    public var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension UserDefaultsClient: TestDependencyKey {
    public static let testValue = Self(
        currentTheme: unimplemented(),
        setCurrentTheme: unimplemented()
    )

    public static let previewValue = Self(
        currentTheme: { 0 },
        setCurrentTheme: { _ in }
    )
}
