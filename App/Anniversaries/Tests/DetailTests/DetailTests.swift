//
//  Created by マハルジャン ビニシュ on 2024/04/07.
//

import Foundation
import XCTest
import ComposableArchitecture
import CoreKit
import SwiftDataClient
import SwiftData
@testable import Detail

@MainActor
final class DetailTests: XCTestCase {
    let container = try! ModelContainer(for: Anniversary.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    func test_EditButtonTapped() async {
        let anniversary = Anniversary(id: UUID(), kind: .birth, othersTitle: "", name: "", date: .now, reminds: [], memo: "")
        let store = TestStore(initialState: Detail.State(anniversary: anniversary)) {
            Detail()
        }
        await store.send(.editButtonTapped) {
            $0.destination = .edit(.init(mode: .edit(store.state.anniversary)))
        }
    }
    
    func test_Delegate_SaveAnniversarySuccessful() async {
        let anniversary = Anniversary(id: UUID(), kind: .birth, othersTitle: "", name: "", date: .now, reminds: [], memo: "")
        let editedAnniversary = Anniversary(id: UUID(), kind: .remembrance, othersTitle: "", name: "", date: .now, reminds: [], memo: "")
        let store = TestStore(initialState: Detail.State(anniversary: anniversary)) {
            Detail()
        }
        
        await store.send(.editButtonTapped) {
            $0.destination = .edit(.init(mode: .edit(store.state.anniversary)))
        }
        
        await store.send(.destination(.presented(.edit(.delegate(.saveAnniversarySuccessful(editedAnniversary)))))) {
            $0.anniversary = editedAnniversary
        }
    }
}
