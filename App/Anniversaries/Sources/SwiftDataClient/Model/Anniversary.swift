//
//  Created by Maharjan Binish on 2023/08/14.
//

import CoreKit
import Foundation
import SwiftData

@Model
public class Anniversary: Identifiable, Equatable {
    public static func == (lhs: Anniversary, rhs: Anniversary) -> Bool {
        lhs.id == rhs.id &&
        lhs.kind == rhs.kind &&
        lhs.othersTitle == rhs.othersTitle &&
        lhs.name == rhs.name &&
        lhs.date == rhs.date &&
        lhs.reminds == rhs.reminds &&
        lhs.memo == rhs.memo
    }

    public init(
        id: UUID,
        kind: AnniversaryKind,
        othersTitle: String?,
        name: String,
        date: Date,
        reminds: [Remind],
        memo: String
    ) {
        self.id = id
        self.kind = kind
        self.othersTitle = othersTitle
        self.name = name
        self.date = date
        self.reminds = reminds
        self.memo = memo
    }
    public var id: UUID
    public var kind: AnniversaryKind
    public var othersTitle: String?
    public var name: String
    public var date: Date
    public var reminds: [Remind]
    public var memo: String
}
