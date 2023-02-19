//
//  Created by クォン ジュンヒョク on 2023/02/19.
//

import UIKit
import ComposableArchitecture

public final class AppDelegate: NSObject, UIApplicationDelegate {
    private var _store: StoreOf<AppDelegateReducer>?

    var store: StoreOf<AppDelegateReducer> {
        if let _store {
            return _store
        }
        let store = Store(initialState: AppDelegateReducer.State(), reducer: AppDelegateReducer())
        self._store = store
        return store
    }

    private(set) lazy var viewStore = ViewStore(store)

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        return true
    }
}

struct AppDelegateReducer: ReducerProtocol {
    struct State: Equatable {
    }

    enum Action {
        case didFinishLaunching
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .didFinishLaunching:
                break
            }
            return .none
        }
    }
}
