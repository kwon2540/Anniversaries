//
//  Created by クォン ジュンヒョク on 2024/08/25.
//

import Dependencies
import Foundation

// MARK: Dependency (testValue, previewValue)
extension UserNotificationClient: TestDependencyKey {
    public static let previewValue = Self.noop
    public static let testValue = Self()
}

extension UserNotificationClient {
    public static let noop = Self(
        add: { _ in },
        delegate: { AsyncStream { _ in } },
        getNotificationSettings: { Notification.Settings(authorizationStatus: .notDetermined) },
        removeDeliveredNotificationsWithIdentifiers: { _ in },
        removePendingNotificationRequestsWithIdentifiers: { _ in },
        requestAuthorization: { _ in false }
    )
}
