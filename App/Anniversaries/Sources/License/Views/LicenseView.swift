//
//  Created by マハルジャン ビニシュ on 2024/03/10.
//

import SwiftUI
import ComposableArchitecture
import AppUI

public struct LicenseView: View {
    public init(store: StoreOf<License>) {
        self.store = store
    }
    
    @State private var selectedLicense: LicensePlugin.License?
    @Bindable private var store: StoreOf<License>
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(LicensePlugin.licenses) { license in
                    NavigationLink {
                        Group {
                            if let licenseText = license.licenseText {
                                ScrollView {
                                    Text(licenseText)
                                        .padding()
                                }
                            }
                        }
                        .navigationTitle(license.name)
                    } label: {
                        Text(license.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .navigationTitle(#localized("License"))
        }
    }
}

#Preview {
    LicenseView(
        store: .init(
            initialState: .init(),
            reducer: License.init
        )
    )
}
