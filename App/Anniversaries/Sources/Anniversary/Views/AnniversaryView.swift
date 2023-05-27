//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import AppUI
import ComposableArchitecture
import SwiftUI

public struct AnniversaryView: View {
    public init(store: StoreOf<Anniversary>) {
        self.store = store
    }

    private var store: StoreOf<Anniversary>
    
    public var body: some View {
        Text("Anniversary")
    }
}

struct AnniversaryView_Previews: PreviewProvider {
    static var previews: some View {
        AnniversaryView(store: .init(initialState: .init(), reducer: Anniversary()))
    }
}
