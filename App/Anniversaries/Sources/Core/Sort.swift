//
//  Created by Maharjan Binish on 2023/05/21.
//

import Foundation


public enum Sort {
    /// Sorting factor for Anniversaries
    public enum Kind: Codable {
        case defaultDate
        case date
        case created
        case name
    }

    /// Sorting order for Anniversaries
    public enum Order: Codable {
        case newest
        case oldest
    }
}
