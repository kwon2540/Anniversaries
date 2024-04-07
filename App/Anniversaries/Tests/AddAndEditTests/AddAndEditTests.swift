//
//  Created by マハルジャン ビニシュ on 2024/03/31.
//

import Foundation
import XCTest
import ComposableArchitecture
import CoreKit
import SwiftDataClient
import SwiftData
import AppUI
@testable import AddAndEdit

@MainActor
final class AddAndEditTests: XCTestCase {
    func test_Binding_SelectedKind() async {
        let store = TestStore(initialState: AddAndEdit.State(mode: .add)) {
            AddAndEdit()
        }
        
        XCTAssertEqual(store.state.selectedKind, .birth)
        await store.send(.set(\.selectedKind, .remembrance)) {
            $0.selectedKind = .remembrance
        } 
        await store.send(.set(\.selectedKind, .others)) {
            $0.selectedKind = .others
            $0.focusedField = .title
        }
    }
    
    func test_CancelButtonTapped() async {
        var isDismissed = false
        let store = TestStore(initialState: AddAndEdit.State(mode: .add)) {
            AddAndEdit()
        } withDependencies: {
            $0.dismiss = .init { isDismissed = true }
        }
        
        await store.send(.cancelButtonTapped)
        XCTAssertTrue(isDismissed)
    }
    
    func test_AddButtonTapped_FailureFlow() async throws {
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: AddAndEdit.State(mode: .add)) {
            AddAndEdit()
        } withDependencies: {
            $0.anniversaryDataClient.insert = { _ in }
            $0.anniversaryDataClient.save = { throw SomeError() }
        }
        
        await store.send(.addButtonTapped)
        await store.receive(\.saveAnniversaries.failure) {
            $0.destination = .alert(AlertState(title: TextState(#localized("Failed to save data"))))
        }
    }
    
    func test_AddButtonTapped_SuccessFlow() async throws {
        var isDismissed = false
        let store = TestStore(initialState: AddAndEdit.State(mode: .add)) {
            AddAndEdit()
        } withDependencies: {
            $0.dismiss = .init { isDismissed = true }
            $0.anniversaryDataClient.insert = { _ in }
            $0.anniversaryDataClient.save = { }
        }
        
        await store.send(.addButtonTapped)
        await store.receive(\.saveAnniversaries.success)
        await store.receive(\.delegate.saveAnniversarySuccessful)
        XCTAssertTrue(isDismissed)
    }
    
    func test_DoneButtonTapped_FailureFlow() async throws {
        let state = AddAndEdit.State(mode: .add)
        let uuid = UUID()
        let date = Date.distantFuture
       
        struct SomeError: Error, Equatable { }
        let store = TestStore(initialState: state) {
            AddAndEdit()
        } withDependencies: {
            $0.userNotificationsClient.add = { _ in throw SomeError() }
            $0.userNotificationsClient.removePendingNotificationRequestsWithIdentifiers = { _ in }
            $0.anniversaryDataClient.insert = { _ in }
            $0.anniversaryDataClient.save = { }
        }
        
        await store.send(.set(\.originalAnniversary, Anniversary(id: uuid, kind: .birth, othersTitle: "", name: "", date: date, reminds: [], memo: ""))) {
            $0.originalAnniversary = Anniversary(id: uuid, kind: .birth, othersTitle: "", name: "", date: date, reminds: [], memo: "")
        }
        
        await store.send(.set(\.reminds, [.init(id: uuid, date: date, isRepeat: true)])) {
            $0.reminds = [.init(id: uuid, date: date, isRepeat: true)]
        }
        
        await store.send(.doneButtonTapped)
        await store.receive(\.saveAnniversaries.failure) {
            $0.destination = .alert(AlertState(title: TextState(#localized("Failed to save data"))))
        }
    }
    
    func test_DoneButtonTapped_SuccessFlow() async throws {
        let state = AddAndEdit.State(mode: .add)
        let uuid = UUID()
        let date = Date.distantFuture
        var isDismissed = false
       
        let store = TestStore(initialState: state) {
            AddAndEdit()
        } withDependencies: {
            $0.userNotificationsClient.add = { _ in }
            $0.userNotificationsClient.removePendingNotificationRequestsWithIdentifiers = { _ in }
            $0.anniversaryDataClient.insert = { _ in }
            $0.anniversaryDataClient.save = { }
            $0.anniversaryDataClient.delete = { _ in }
            $0.dismiss = .init { isDismissed = true }
        }
        
        await store.send(.set(\.originalAnniversary, Anniversary(id: uuid, kind: .birth, othersTitle: "", name: "", date: date, reminds: [], memo: ""))) {
            $0.originalAnniversary = Anniversary(id: uuid, kind: .birth, othersTitle: "", name: "", date: date, reminds: [], memo: "")
        }
        
        await store.send(.set(\.reminds, [.init(id: uuid, date: date, isRepeat: true)])) {
            $0.reminds = [.init(id: uuid, date: date, isRepeat: true)]
        }
        
        await store.send(.doneButtonTapped)
        await store.receive(\.saveAnniversaries.success)
        await store.receive(\.delegate.saveAnniversarySuccessful)
        XCTAssertTrue(isDismissed)
    }
    
    func test_AddRemindButtonTapped() async {
        let store = TestStore(initialState: AddAndEdit.State(mode: .add)) {
            AddAndEdit()
        }
        await store.send(.addRemindButtonTapped) {
            $0.destination = .remind(.init(anniversaryDate: store.state.date))
        }
    }
    
    func test_RemindTapped() async {
        let remind = Remind(id: UUID(), date: .now, isRepeat: false)
        let store = TestStore(initialState: AddAndEdit.State(mode: .add)) {
            AddAndEdit()
        }
        await store.send(.remindTapped(remind)) {
            $0.destination = .remind(.init(remind: remind))
        }
    }
    
    func test_DeleteRemind() async {
        let reminds = [
            Remind(id: UUID(), date: .now, isRepeat: false),
            Remind(id: UUID(), date: .distantFuture, isRepeat: true),
        ]
        let deleteIndexSet = IndexSet(integer: 0)
        let store = TestStore(initialState: AddAndEdit.State(mode: .add)) {
            AddAndEdit()
        }
        await store.send(.set(\.reminds, reminds)) {
            $0.reminds = reminds
        }
        await store.send(.deleteRemind(deleteIndexSet)) {
            $0.reminds.remove(atOffsets: deleteIndexSet)
        }
    }
}
