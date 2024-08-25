//
//  Created by クォン ジュンヒョク on 2024/08/25.
//

import Dependencies
import Foundation

// MARK: Dependency (testValue, previewValue)
extension UserDefaultsClient: TestDependencyKey {
    public static let previewValue = Self.noop
    public static let testValue = Self()
}

extension UserDefaultsClient {
    public static let noop = Self(
        currentAnniversariesSort: { .date },
        setCurrentAnniversariesSort: { _ in },
        currentAnniversariesSortOrder: { .ascending },
        setCurrentAnniversariesSortOrder: { _ in }
    )
}
