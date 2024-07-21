//
//  Created by マハルジャン ビニシュ on 2024/06/30.
//

import Dependencies
import WidgetKit

public struct WidgetCenterClient {
    public var reloadAllTimelines: () -> Void
}

extension DependencyValues {
    public var widgetCenterClient: WidgetCenterClient {
        get { self[WidgetCenterClient.self] }
        set { self[WidgetCenterClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension WidgetCenterClient: TestDependencyKey {
    public static let testValue = Self(
        reloadAllTimelines: unimplemented()
    )

    public static let previewValue = Self(
        reloadAllTimelines: {  }
    )
}
