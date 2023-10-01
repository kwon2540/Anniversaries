//
//  Created by Maharjan Binish on 2023/08/27.
//

import Foundation

public struct Remind: Hashable, Codable {
    public init(date: Date, isRepeat: Bool) {
        self.date = date
        self.isRepeat = isRepeat
    }

    /// Remind Date
    public var date: Date
    /// Flag for repeat remind date
    public var isRepeat: Bool
}
