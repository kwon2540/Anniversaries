//
//  Created by マハルジャン ビニシュ on 2024/06/30.
//

import Dependencies
import DependenciesMacros
import WidgetKit

extension DependencyValues {
    public var widgetCenterClient: WidgetCenterClient {
        get { self[WidgetCenterClient.self] }
        set { self[WidgetCenterClient.self] = newValue }
    }
}

@DependencyClient
public struct WidgetCenterClient {
    public var reloadAllTimelines: () -> Void = { }
}
