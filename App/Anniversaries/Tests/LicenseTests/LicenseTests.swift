//
//  Created by マハルジャン ビニシュ on 2024/04/14.
//

import Foundation
import XCTest
import ComposableArchitecture
@testable import License

@MainActor
final class LicenseTests: XCTestCase {
    func test_CloseButtonTapped() async throws {
        var isDismissed = false
        let store = TestStore(initialState: License.State()) {
            License()
        } withDependencies: {
            $0.dismiss = .init { isDismissed = true }
        }
        
        await store.send(.closeButtonTapped)
        XCTAssertTrue(isDismissed)
    }
}
