//
//  Created by クォン ジュンヒョク on 2023/10/22.
//

import Foundation
import CoreKit

public extension AnniversaryKind {
    var title: String {
        switch self {
        case .birth:
            return #localized("Birthday")
        case .remembrance:
            return #localized("Remembrance Day")
        case .others:
            return #localized("Others")
        }
    }
}
