//
//  Created by Maharjan Binish on 2023/05/21.
//

import Foundation


public enum Sort {
    /// Sorting factor for Anniversaries
    public enum Kind: CaseIterable, Codable {
        case defaultCategory
        case date
        case name
    }

    /// Sorting order for Anniversaries
    public enum Order: CaseIterable, Codable {
        case ascending
        case descending
    }
}
