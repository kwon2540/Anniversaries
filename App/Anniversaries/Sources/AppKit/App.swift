//
//  Created by クォン ジュンヒョク on 2023/02/19.
//

import SwiftUI

public protocol App: SwiftUI.App {
    var appDelegate: AppDelegate { get }
}

extension App {
    public var body: some Scene {
        WindowGroup {
            Text("Hello world")
        }
    }
}
