//
//  Created by マハルジャン ビニシュ on 2023/12/24.
//

import Foundation
import UserNotifications
import Dependencies
import DependenciesMacros

public extension UserNotificationClient {
    static let anniversaryIDKey = "anniversaryID"
}

extension DependencyValues {
    public var userNotificationsClient: UserNotificationClient {
        get { self[UserNotificationClient.self] }
        set { self[UserNotificationClient.self] = newValue }
    }
}

@DependencyClient
public struct UserNotificationClient {
    public var add: @Sendable (UNNotificationRequest) async throws -> Void
    public var delegate: @Sendable () -> AsyncStream<DelegateEvent> = { .never }
    public var getNotificationSettings: @Sendable () async -> Notification.Settings = { .init(authorizationStatus: .authorized) }
    public var removeDeliveredNotificationsWithIdentifiers: @Sendable ([String]) async -> Void
    public var removePendingNotificationRequestsWithIdentifiers: @Sendable ([String]) async -> Void
    public var requestAuthorization: @Sendable (UNAuthorizationOptions) async throws -> Bool
    
    public enum DelegateEvent: Equatable {
        case didReceiveResponse(Notification.Response, completionHandler: @Sendable () -> Void)
        case willPresentNotification(
            Notification, completionHandler: @Sendable (UNNotificationPresentationOptions) -> Void
        )
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.didReceiveResponse(lhs, _), .didReceiveResponse(rhs, _)):
                return lhs == rhs
            case let (.willPresentNotification(lhs, _), .willPresentNotification(rhs, _)):
                return lhs == rhs
            default:
                return false
            }
        }
    }
    
    public struct Notification: Equatable {
        public var date: Date
        public var request: UNNotificationRequest
        
        public init(date: Date, request: UNNotificationRequest) {
            self.date = date
            self.request = request
        }
        
        public struct Response: Equatable {
            public var notification: Notification
            
            public init(notification: Notification) {
                self.notification = notification
            }
        }
        
        public struct Settings: Equatable {
            public var authorizationStatus: UNAuthorizationStatus
            
            public init(authorizationStatus: UNAuthorizationStatus) {
                self.authorizationStatus = authorizationStatus
            }
        }
    }
}
