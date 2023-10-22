//
//  Created by Maharjan Binish on 2023/03/19.
//

import CoreKit
import Foundation
import Dependencies

public struct UserDefaultsClient {
    public var currentAnniversariesSort: () -> Sort.Kind
    public var setCurrentAnniversariesSort: (Sort.Kind) -> Void
    public var currentAnniversariesSortOrder: () -> Sort.Order
    public var setCurrentAnniversariesSortOrder: (Sort.Order) -> Void
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
        currentAnniversariesSort: unimplemented(),
        setCurrentAnniversariesSort: unimplemented(),
        currentAnniversariesSortOrder: unimplemented(),
        setCurrentAnniversariesSortOrder: unimplemented()
    )

    public static let previewValue = Self(
        currentAnniversariesSort: { .date },
        setCurrentAnniversariesSort: { _ in },
        currentAnniversariesSortOrder: { .newest },
        setCurrentAnniversariesSortOrder: { _ in }
    )
}
