//
//  Created by マハルジャン ビニシュ on 2024/03/10.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct License {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var licenses = LicensePlugin.licenses
    }
    
    public init() { }
}
