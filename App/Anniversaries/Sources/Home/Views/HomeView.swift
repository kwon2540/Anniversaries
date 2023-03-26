//
//  Created by Maharjan Binish on 2023/03/05.
//

import AppUI
import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    public init(store: StoreOf<Home>) {
        self.store = store
    }

    var store: StoreOf<Home>
    
    public var body: some View {
        Text(L10n.Home.title)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: .init(
                initialState: .init(
                    anniversaries: "Anniversaries",
                    themeState: .init()
                ),
                reducer: Home()
            )
        )
    }
}
