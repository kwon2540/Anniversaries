//
//  Created by クォン ジュンヒョク on 2024/08/25.
//

import Foundation
import Dependencies
import SwiftData

// - MARK: Dependency (liveValue)
extension AnniversaryDataClient: DependencyKey {
    public static var liveValue = AnniversaryDataClient.live()
}

// MARK: - Live Implementation
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
            },
            query: { id in
                struct QueryError: Error { }

                guard let uuid = UUID(uuidString: id),
                      let anniversary = try context.fetch(
                        FetchDescriptor<Anniversary>(
                            predicate: #Predicate<Anniversary> { $0.id == uuid }
                        )
                      ).first else {
                    throw QueryError()
                }

                return anniversary
            },
            delete: { anniversary in
                context.delete(anniversary)
            }
        )
    }
}
