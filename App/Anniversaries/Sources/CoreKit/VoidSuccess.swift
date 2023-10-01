//
//  Created by クォン ジュンヒョク on 2023/10/01.
//

import Foundation
import ComposableArchitecture

public struct VoidSuccess: Codable, Sendable, Hashable {
    public init() {}
}

extension TaskResult where Success == VoidSuccess {
    public init(catching body: @Sendable () async throws -> Void) async {
        do {
            try await body()
            self = .success(VoidSuccess())
        } catch {
            self = .failure(error)
        }
    }
}
