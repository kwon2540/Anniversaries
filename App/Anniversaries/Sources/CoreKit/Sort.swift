//
//  Created by Maharjan Binish on 2023/05/21.
//

import Foundation


public enum Sort {
    /// Sorting factor for Anniversaries
    public enum Kind: String, CaseIterable, Codable {
        case defaultDate = "Default(Date)"
        case date = "Date"
        case created = "Created"
        case name = "Name"
    }

    /// Sorting order for Anniversaries
    public enum Order: String, CaseIterable, Codable {
        case newest = "Newest First"
        case oldest = "Oldest First"
    }
}
