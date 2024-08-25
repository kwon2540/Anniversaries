//
//  Created by マハルジャン ビニシュ on 2024/06/30.
//

import Dependencies
import WidgetKit

// - MARK: Dependency (liveValue)
extension WidgetCenterClient: DependencyKey {
    public static let liveValue = Self.live(widgetCenter: .shared)
}

// MARK: - Live Implementation
extension WidgetCenterClient {
    public static func live(widgetCenter: WidgetCenter) -> Self {
        Self(
            reloadAllTimelines: {
                widgetCenter.reloadAllTimelines()
            }
        )
    }
}
