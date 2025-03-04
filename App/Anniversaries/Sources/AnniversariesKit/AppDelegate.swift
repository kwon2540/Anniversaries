//
//  Created by クォン ジュンヒョク on 2023/02/19.
//

import AppFeature
import AppUI
import ComposableArchitecture
import FirebaseCore
import SwiftUI
import UIKit
import UserNotificationClient

public final class AppDelegate: NSObject, UIApplicationDelegate {
    private var _store: StoreOf<AppDelegateReducer>?
    
    var store: StoreOf<AppDelegateReducer> {
        if let _store {
            return _store
        }
        let store = Store(initialState: AppDelegateReducer.State(), reducer: AppDelegateReducer.init)
        self._store = store
        return store
    }
    
    private(set) lazy var viewStore = ViewStore(store, observe: { $0 })
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(#color("tint"))]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(#color("tint"))]

        viewStore.send(.didFinishLaunching)

        return true
    }
}

@Reducer
struct AppDelegateReducer {
    @ObservableState
    struct State: Equatable {
        var rootState = Root.State()
    }
    
    enum Action {
        case didFinishLaunching
        case rootAction(Root.Action)
        case userNotifications(UserNotificationClient.DelegateEvent)
    }
    
    @Dependency(\.userNotificationsClient) var userNotificationsClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didFinishLaunching:
                FirebaseApp.configure()
                let userNotificationsEventStream = userNotificationsClient.delegate()
                
                return .run { send in
                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {
                            for await event in userNotificationsEventStream {
                                await send(.userNotifications(event))
                            }
                        }
                        
                        group.addTask {
                            _ = try await userNotificationsClient.requestAuthorization([.alert, .sound])
                        }
                    }
                }
                
            case .userNotifications(.willPresentNotification(_, let completionHandler)):
                return .run { _ in completionHandler(.banner) }
                
            case .userNotifications(.didReceiveResponse(let response, let completionHandler)):
                return .run { send in
                    if let anniversaryID = response.notification.request.content.userInfo[UserNotificationClient.anniversaryIDKey] as? String {
                        await send(.rootAction(.homeAction(.userNotificationTapped(id: anniversaryID))))
                    }
                    await MainActor.run {
                        completionHandler()
                    }
                }

            case .rootAction, .userNotifications:
                break
            }
            return .none
        }
        
        Scope(state: \.rootState, action: \.rootAction) {
            Root()
        }
    }
}
