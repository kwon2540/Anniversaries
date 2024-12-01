//
//  Created by Maharjan Binish on 2023/09/17.
//

import SwiftData
import CoreKit
import Dependencies
import DependenciesMacros
import Foundation
import SwiftUI

/// ModelContainer for Anniversary
public var anniversaryContainer = {
    guard let container = try? ModelContainer(for: Anniversary.self) else {
        fatalError("Failed to create ModelContainer For Anniversary.")
    }
    return container
}()

extension DependencyValues {
    public var anniversaryDataClient: AnniversaryDataClient {
        get { self[AnniversaryDataClient.self] }
        set { self[AnniversaryDataClient.self] = newValue }
    }
}

@DependencyClient
public struct AnniversaryDataClient {
    public var insert: @Sendable (Anniversary) async -> Void
    public var save: @Sendable () async throws -> Void
    public var fetch: @Sendable () async throws -> [Anniversary]
    public var query: @Sendable (String) async throws -> Anniversary
    public var delete: @Sendable (Anniversary) async -> Void
}

