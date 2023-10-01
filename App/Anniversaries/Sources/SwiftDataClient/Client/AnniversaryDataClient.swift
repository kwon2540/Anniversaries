//
//  Created by Maharjan Binish on 2023/09/17.
//

import SwiftData
import CoreKit
import Dependencies

/// ModelContainer for Anniversary
public var anniversaryContainer = {
    guard let container = try? ModelContainer(for: Anniversary.self) else {
        fatalError("Failed to create ModelContainer For Anniversary.")
    }
    return container
}()

public struct AnniversaryDataClient {
    public var insert: (Anniversary) -> Void
    public var save: () throws -> Void
    public var fetch: () throws -> [Anniversary]
}

// MARK: - Register as a DependencyValue

extension DependencyValues {
    public var anniversaryDataClient: AnniversaryDataClient {
        get { self[AnniversaryDataClient.self] }
        set { self[AnniversaryDataClient.self] = newValue }
    }
}

extension AnniversaryDataClient: TestDependencyKey {
    public static var testValue = AnniversaryDataClient(
        insert: unimplemented(),
        save: unimplemented(),
        fetch: unimplemented()
    )

    public static var previewValue = AnniversaryDataClient(
        insert: unimplemented(),
        save: unimplemented(),
        fetch: {
            [
                Anniversary(
                    kind: .birth,
                    othersTitle: nil,
                    name: "Test Data",
                    date: .now,
                    reminds: [],
                    memo: "Test Memo"
                )
            ]
        }
    )
}

extension AnniversaryDataClient: DependencyKey {
    public static var liveValue = AnniversaryDataClient.live()
}

extension AnniversaryDataClient {
    private static func live() -> AnniversaryDataClient {
        let context = ModelContext(anniversaryContainer)

        return AnniversaryDataClient(
            insert: { anniversary in
                context.insert(anniversary)
            },
            save: {
                try context.save()
            },
            fetch: {
                try context.fetch(FetchDescriptor<Anniversary>())
            }
        )
    }
}
