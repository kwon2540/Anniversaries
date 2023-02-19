//
//  Created by Maharjan Binish on 2023/02/19.
//

import ComposableArchitecture
import SwiftUI

public struct RootView: View {
    private let store: StoreOf<Root>

    public init(store: StoreOf<Root>) {
        self.store = store
    }

    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                initialState: .init(),
                reducer: Root()
            )
        )
    }
}
