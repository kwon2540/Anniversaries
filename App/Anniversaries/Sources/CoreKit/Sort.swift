//
//  Created by Maharjan Binish on 2023/05/21.
//

import Foundation
import SwiftUI

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

extension Binding where Value == Sort.Kind {
    public func isOn(sort: Sort.Kind) -> Binding<Bool> {
        .init(
            get: { wrappedValue == sort },
            set: { isOn, transaction in
                if isOn {
                    self.transaction(transaction).wrappedValue = sort
                }
            }
        )
    }
}

extension Binding where Value == Sort.Order {
    public func isOn(sortOrder: Sort.Order) -> Binding<Bool> {
        .init(
            get: { wrappedValue == sortOrder },
            set: { isOn, transaction in
                if isOn {
                    self.transaction(transaction).wrappedValue = sortOrder
                }
            }
        )
    }
}
