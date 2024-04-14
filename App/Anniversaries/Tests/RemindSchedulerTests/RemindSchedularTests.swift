//
//  Created by マハルジャン ビニシュ on 2024/04/14.
//

import Foundation
import XCTest
import ComposableArchitecture
import CoreKit
@testable import RemindScheduler

@MainActor
final class RemindSchedulerTests: XCTestCase {
    func test_Binding_IsCustomTime() async {
        let store = TestStore(initialState: RemindScheduler.State(anniversaryDate: .now)) {
            RemindScheduler()
        }
        
        XCTAssertFalse(store.state.isCustomTime)
        await store.send(.set(\.isCustomTime, true)) {
            $0.isCustomTime = true
            $0.isTimeExpanded = true
        }
        
        await store.send(.set(\.isCustomTime, false)) {
            $0.isCustomTime = false
            $0.selectedDate = Calendar.current.startOfDay(for: $0.selectedDate)
            $0.isTimeExpanded = false
        }
    }
    
    func test_CancelButtonTapped() async {
        var isDismissed = false
        let store = TestStore(initialState: RemindScheduler.State(anniversaryDate: .now)) {
            RemindScheduler()
        } withDependencies: {
            $0.dismiss = .init { isDismissed = true }
        }
        
        await store.send(.cancelButtonTapped)
        XCTAssertTrue(isDismissed)
    }
    
    func test_NavigationTrailingButtonTapped_AddFlow() async {
        var isDismissed = false
        let store = TestStore(initialState: RemindScheduler.State(anniversaryDate: .now)) {
            RemindScheduler()
        } withDependencies: {
            $0.uuid = .incrementing
            $0.dismiss = .init { isDismissed = true }
        }
        
        await store.send(.navigationTrailingButtonTapped)
        await store.receive(\.delegate.remindApplied)
        XCTAssertTrue(isDismissed)
    }
    
    func test_NavigationTrailingButtonTapped_EditFlow() async {
        let remind = Remind(id: UUID(), date: .now, isRepeat: true)
        var isDismissed = false
        let store = TestStore(initialState: RemindScheduler.State(remind: remind)) {
            RemindScheduler()
        } withDependencies: {
            $0.uuid = .incrementing
            $0.dismiss = .init { isDismissed = true }
        }
        
        await store.send(.navigationTrailingButtonTapped)
        await store.receive(\.delegate.remindEdited)
        XCTAssertTrue(isDismissed)
    }
    
    func test_DateTapped() async {
        let store = TestStore(initialState: RemindScheduler.State(anniversaryDate: .now)) {
            RemindScheduler()
        }
        
        XCTAssertTrue(store.state.isDateExpanded)
        await store.send(.dateTapped) {
            $0.isDateExpanded = !store.state.isDateExpanded
        }
    }
    
    func test_TimeTapped() async {
        let store = TestStore(initialState: RemindScheduler.State(anniversaryDate: .now)) {
            RemindScheduler()
        }
        
        XCTAssertFalse(store.state.isTimeExpanded)
        await store.send(.timeTapped) {
            $0.isTimeExpanded = !store.state.isTimeExpanded
        }
    }
}
