//
//  Created by Maharjan Binish on 2023/03/19.
//

import CoreKit
import Foundation
import Dependencies
import DependenciesMacros

extension DependencyValues {
    public var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

@DependencyClient
public struct UserDefaultsClient {
    public var currentAnniversariesSort: () -> Sort.Kind = { .name }
    public var setCurrentAnniversariesSort: (Sort.Kind) -> Void
    public var currentAnniversariesSortOrder: () -> Sort.Order = { .ascending }
    public var setCurrentAnniversariesSortOrder: (Sort.Order) -> Void
}
