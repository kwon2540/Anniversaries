//
//  Created by Maharjan Binish on 2023/07/16.
//

import ComposableArchitecture
import SwiftUI

public struct RemindSchedulerView: View {
    public init(store: StoreOf<RemindScheduler>) {
        self.store = store
    }

    private let store: StoreOf<RemindScheduler>

    public var body: some View {
        Text("Hello World")
    }
}

#Preview {
    RemindSchedulerView(
        store: .init(
            initialState: RemindScheduler.State(),
            reducer: RemindScheduler()
        )
    )
}
