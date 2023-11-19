//
//  Created by クォン ジュンヒョク on 2023/10/22.
//

import Foundation
import SwiftDataClient
import CoreKit

struct GroupedAnniversaries: Hashable {
    var key: String
    var anniversaries: [Anniversary]
}


extension GroupedAnniversaries {
    init(element: Dictionary<Date.FormatStyle.FormatOutput, [Anniversary]>.Element) {
        self.key = element.key
        self.anniversaries = element.value
    }

    init(element: Dictionary<AnniversaryKind, [Anniversary]>.Element) {
        self.key = element.key.title
        self.anniversaries = element.value
    }
}
