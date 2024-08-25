//
//  Created by クォン ジュンヒョク on 2024/08/25.
//

import Foundation
import Dependencies
import SwiftData

// MARK: Dependency (testValue, previewValue)
extension AnniversaryDataClient: TestDependencyKey {
    public static var previewValue = Self.noop
    public static var testValue = Self.test()
}

extension AnniversaryDataClient {
    public static let noop = Self(
        insert: unimplemented(),
        save: unimplemented(),
        fetch: {
            [
                Anniversary(
                    id: UUID(),
                    kind: .birth,
                    othersTitle: "",
                    name: "Test Data",
                    date: .now,
                    reminds: [],
                    memo: "Test Memo"
                ),
                Anniversary(
                    id: UUID(),
                    kind: .others,
                    othersTitle: "Test Title",
                    name: "Test Data",
                    date: .now,
                    reminds: [],
                    memo: "Test Memo"
                ),
                Anniversary(
                    id: UUID(),
                    kind: .birth,
                    othersTitle: "",
                    name: "Test Data",
                    date: .now,
                    reminds: [.init(id: UUID(), date: .now, isRepeat: false)],
                    memo: "Test Memo"
                ),
                Anniversary(
                    id: UUID(),
                    kind: .birth,
                    othersTitle: "",
                    name: "Test Data",
                    date: .now,
                    reminds: [],
                    memo: ""
                )
            ]
        },
        query: { _ in
            Anniversary(
                id: UUID(),
                kind: .birth,
                othersTitle: "",
                name: "Test Data",
                date: .now,
                reminds: [],
                memo: "Test Memo"
            )
        },
        delete: unimplemented()
    )

    public static func test() -> AnniversaryDataClient {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Anniversary.self, configurations: config)
        let context = ModelContext(container)

        // Note: For test to work, at least one model should be inserted so that the context is used.
        context.insert(
            Anniversary(
                id: .init(),
                kind: .others,
                othersTitle: "",
                name: "",
                date: .now,
                reminds: [],
                memo: ""
            )
        )

        return AnniversaryDataClient(
            insert: unimplemented("\(Self.self).insert"),
            save: unimplemented("\(Self.self).save"),
            fetch: unimplemented("\(Self.self).fetch"),
            query: unimplemented("\(Self.self).query"),
            delete: unimplemented("\(Self.self).delete")
        )
    }
}
