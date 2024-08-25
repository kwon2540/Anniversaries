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
    public var insert: (Anniversary) -> Void
    public var save: () throws -> Void
    public var fetch: () throws -> [Anniversary]
    public var query: (String) throws -> Anniversary
    public var delete: (Anniversary) -> Void
}

