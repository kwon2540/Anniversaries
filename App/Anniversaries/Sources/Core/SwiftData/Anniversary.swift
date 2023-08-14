//
//  Created by Maharjan Binish on 2023/08/14.
//

import Foundation
import SwiftData

@Model
public class Anniversary {
    public var reminds: [Remind]
}

public struct Remind {
    public init(date: Date, isRepeat: Bool) {
        self.date = date
        self.isRepeat = isRepeat
    }

    /// Remind Date
    public var date: Date
    /// Flag for repeat remind date
    public var isRepeat: Bool
}
