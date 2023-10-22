//
//  Created by Maharjan Binish on 2023/08/14.
//

import CoreKit
import Foundation
import SwiftData

@Model
public class Anniversary {
    public init(
        kind: AnniversaryKind,
        othersTitle: String?,
        name: String,
        date: Date,
        reminds: [Remind],
        memo: String
    ) {
        self.kind = kind
        self.othersTitle = othersTitle
        self.name = name
        self.date = date
        self.reminds = reminds
        self.memo = memo
    }

    public var kind: AnniversaryKind
    public var othersTitle: String?
    public var name: String
    public var date: Date
    public var reminds: [Remind]
    public var memo: String
}

extension Anniversary {
    public var month: Date.FormatStyle.FormatOutput {
        date.formatted(.dateTime.month())
    }

    public var digitsMonth: Int {
        Int(date.formatted(.dateTime.month(.defaultDigits))) ?? 0
    }
}
