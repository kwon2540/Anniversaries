//
//  Created by マハルジャン ビニシュ on 2024/04/07.
//

import Foundation
import XCTest
import ComposableArchitecture
import CoreKit
import SwiftDataClient
import SwiftData
import AppUI
@testable import Home

@MainActor
final class HomeTests: XCTestCase {
    let container = try! ModelContainer(for: Anniversary.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    func test_OnAppear() async {
        let currentSort = Sort.Kind.date
        let currentSortOrder = Sort.Order.descending
        let store = TestStore(initialState: Home.State()) {
            Home()
        } withDependencies: {
            $0.userDefaultsClient.currentAnniversariesSort = { currentSort }
            $0.userDefaultsClient.currentAnniversariesSortOrder = { currentSortOrder }
            $0.anniversaryDataClient.fetch = { [] }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear) {
            $0.currentSort = currentSort
            $0.currentSortOrder = currentSortOrder
        }
        
        await store.receive(\.fetchAnniversaries)
    }
    
    func test_FetchAnniversary_FailureFlow() async {
        struct SomeError: Error { }
        let store = TestStore(initialState: Home.State()) {
            Home()
        } withDependencies: {
            $0.anniversaryDataClient.fetch = { throw SomeError() }
        }
        
        await store.send(.fetchAnniversaries)
        await store.receive(\.anniversariesResponse.failure) {
            $0.destination = .alert(
                AlertState(title: TextState(#localized("Failed to load anniversary")))
            )
        }
    }
    
    func test_FetchAnniversary_SuccessFlow() async {
        let anniversaries: [Anniversary] = []
        let store = TestStore(initialState: Home.State()) {
            Home()
        } withDependencies: {
            $0.anniversaryDataClient.fetch = { anniversaries }
        }
        
        store.exhaustivity = .off
        
        await store.send(.fetchAnniversaries)
        await store.receive(\.anniversariesResponse.success) {
            $0.anniversaries = anniversaries
        }
        
        await store.receive(\.sortAnniversaries)
    }
    
    func test_SortAnniversaries() async {
        let anniversaries = [
            Anniversary(id: UUID(), kind: .remembrance, othersTitle: "", name: "", date: .now, reminds: [], memo: ""),
            Anniversary(id: UUID(), kind: .birth, othersTitle: "", name: "", date: .now, reminds: [], memo: ""),
        ]

        let store = TestStore(initialState: Home.State()) {
            Home()
        }
        
        await store.send(.set(\.anniversaries, anniversaries)) {
            $0.anniversaries = anniversaries
        }
        
        await store.send(.sortAnniversaries) {
            $0.groupedAnniversariesList = anniversaries.sorted(by: $0.currentSort, order: $0.currentSortOrder)
        }
    }
    
    func test_EditButtonTapped() async {
        let store = TestStore(initialState: Home.State()) {
            Home()
        }
        
        XCTAssertEqual(store.state.editMode, .inactive)
        
        await store.send(.editButtonTapped) {
            $0.editMode  = .active
        }
    }
    
    func test_EditDoneButtonTapped() async {
        let store = TestStore(initialState: Home.State()) {
            Home()
        }
        
        await store.send(.editButtonTapped) {
            $0.editMode  = .active
        }
        
        await store.send(.editDoneButtonTapped) {
            $0.editMode  = .inactive
        }
    }
    
    func test_SortByButtonTapped() async {
        let store = TestStore(initialState: Home.State()) {
            Home()
        } withDependencies: {
            $0.userDefaultsClient.setCurrentAnniversariesSort = { _ in }
        }
        
        let sort = Sort.Kind.date
        
        await store.send(.sortByButtonTapped(sort)) {
            $0.currentSort = sort
        }
        
        await store.receive(\.sortAnniversaries)
    }
    
    func test_SortOrderButtonTapped() async {
        let store = TestStore(initialState: Home.State()) {
            Home()
        } withDependencies: {
            $0.userDefaultsClient.setCurrentAnniversariesSortOrder = { _ in }
        }
        
        let sortOrder = Sort.Order.descending
        
        await store.send(.sortOrderButtonTapped(sortOrder)) {
            $0.currentSortOrder = sortOrder
        }
        
        await store.receive(\.sortAnniversaries)
    }
    
    func test_AddButtonTapped() async {
        let store = TestStore(initialState: Home.State()) {
            Home()
        }
        
        await store.send(.addButtonTapped) {
            $0.destination = .add(.init(mode: .add))
        }
    }
    
    func test_LicenseButtonTapped() async {
        let store = TestStore(initialState: Home.State()) {
            Home()
        }
        
        await store.send(.licenseButtonTapped) {
            $0.destination = .license(.init())
        }
    }
    
    func test_AnniversaryTapped() async {
        let anniversary = Anniversary(id: UUID(), kind: .remembrance, othersTitle: "", name: "", date: .now, reminds: [], memo: "")
        let store = TestStore(initialState: Home.State()) {
            Home()
        }
        
        await store.send(.anniversaryTapped(anniversary)) {
            $0.destination = .detail(.init(anniversary: anniversary))
        }
    }
    
    func test_OnDeleteAnniversary_FailureFlow() async {
        struct SomeError: Error { }
        let anniversary = Anniversary(id: UUID(), kind: .remembrance, othersTitle: "", name: "", date: .now, reminds: [], memo: "")
        let clock = TestClock()
        let store = TestStore(initialState: Home.State()) {
            Home()
        } withDependencies: {
            $0.continuousClock = clock
            $0.anniversaryDataClient.delete = { _ in }
            $0.anniversaryDataClient.save = { throw SomeError() }
        }
        
        await store.send(.onDeleteAnniversary(anniversary))
        
        await clock.advance(by: .seconds(0.3))
        await store.receive(\.deleteAnniversary.failure) {
            $0.destination = .alert(
                AlertState {
                    TextState(#localized("Failed to delete anniversary"))
                } actions: {
                    ButtonState(action: .onDismissed) { TextState(#localized("OK")) }
                }
            )
        }
    }
    
    func test_OnDeleteAnniversary_SuccessFlow() async {
        let anniversary = Anniversary(id: UUID(), kind: .remembrance, othersTitle: "", name: "", date: .now, reminds: [], memo: "")
        let clock = TestClock()
        let store = TestStore(initialState: Home.State()) {
            Home()
        } withDependencies: {
            $0.continuousClock = clock
            $0.anniversaryDataClient.delete = { _ in }
            $0.anniversaryDataClient.save = { }
            $0.anniversaryDataClient.fetch = { [] }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onDeleteAnniversary(anniversary))
        
        await clock.advance(by: .seconds(0.3))
        await store.receive(\.deleteAnniversary.success)
    }
}
