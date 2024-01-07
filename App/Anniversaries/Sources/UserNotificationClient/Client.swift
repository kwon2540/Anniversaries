//
//  Created by マハルジャン ビニシュ on 2023/12/24.
//

import Foundation
import ComposableArchitecture
import UserNotifications
import Dependencies
import XCTestDynamicOverlay

public struct UserNotificationClient {
    public var add: @Sendable (UNNotificationRequest) async throws -> Void
    public var delegate: @Sendable () -> AsyncStream<DelegateEvent>
    public var getNotificationSettings: @Sendable () async -> Notification.Settings
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


extension DependencyValues {
    public var userNotificationsClient: UserNotificationClient {
        get { self[UserNotificationClient.self] }
        set { self[UserNotificationClient.self] = newValue }
    }
}

extension UserNotificationClient: TestDependencyKey {
    public static let previewValue = Self.noop
    
    public static let testValue = Self(
        add: XCTUnimplemented("\(Self.self).add"),
        delegate: XCTUnimplemented("\(Self.self).delegate", placeholder: .finished),
        getNotificationSettings: XCTUnimplemented(
            "\(Self.self).getNotificationSettings",
            placeholder: Notification.Settings(authorizationStatus: .notDetermined)
        ),
        removeDeliveredNotificationsWithIdentifiers: XCTUnimplemented(
            "\(Self.self).removeDeliveredNotificationsWithIdentifiers"),
        removePendingNotificationRequestsWithIdentifiers: XCTUnimplemented(
            "\(Self.self).removePendingNotificationRequestsWithIdentifiers"),
        requestAuthorization: XCTUnimplemented("\(Self.self).requestAuthorization")
    )
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
