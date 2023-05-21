//
//  Created by Maharjan Binish on 2023/05/21.
//

import Foundation

/// Sorting factor for Anniversaries
public enum Sort: Equatable, Codable {
    case date
    case created
    case name
}

/// Sorting order for Anniversaries
public enum SortOrder: Equatable, Codable {
    case newest
    case oldest
}
