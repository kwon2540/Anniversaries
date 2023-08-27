//
//  Created by Maharjan Binish on 2023/08/14.
//

import Foundation
import SwiftData

@Model
public class Anniversary {
    public init(
//        kind: AnniversaryKind,
        othersTitle: String?,
        name: String,
//        date: Date,
//        reminds: [Remind],
        memo: String
    ) {
//        self.kind = kind
        self.othersTitle = othersTitle
        self.name = name
//        self.date = date
//        self.reminds = reminds
        self.memo = memo
    }

//    public var kind: AnniversaryKind
    public var othersTitle: String?
    public var name: String
//    public var date: Date
//    public var reminds: [Remind]
    public var memo: String
}

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
