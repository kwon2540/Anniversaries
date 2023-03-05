//
//  Created by Maharjan Binish on 2023/02/26.
//

import ComposableArchitecture
import SwiftUI

struct LaunchView: View {
    var store: StoreOf<Launch>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("LaunchView")
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .alert(
                    store.scope(
                        state: \.alertState,
                        action: Launch.Action.alertAction
                    ),
                    dismiss: .onDismiss
                )
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(
            store: Store(
                initialState: .init(),
                reducer: Launch()
            )
        )
    }
}
