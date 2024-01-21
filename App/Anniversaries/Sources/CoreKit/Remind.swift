//
//  Created by Maharjan Binish on 2023/08/27.
//

import Foundation
import Dependencies

public struct Remind: Hashable, Identifiable, Codable {
    public init(date: Date, isRepeat: Bool) {
        @Dependency(\.uuid) var uuid
        self.id = uuid()
        self.date = date
        self.isRepeat = isRepeat
    }

    public var id: UUID
    /// Remind Date
    public var date: Date
    /// Flag for repeat remind date
    public var isRepeat: Bool
}
