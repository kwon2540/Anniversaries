//
//  Created by クォン ジュンヒョク on 2024/08/25.
//

import Dependencies
import Foundation

// MARK: Dependency (testValue, previewValue)
extension WidgetCenterClient: TestDependencyKey {
    public static let previewValue = Self.noop
    public static let testValue = Self()
}

extension WidgetCenterClient {
    public static let noop = Self(
        reloadAllTimelines: { }
    )
}
