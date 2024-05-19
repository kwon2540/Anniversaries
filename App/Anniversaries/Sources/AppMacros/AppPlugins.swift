//
//  Created by Maharjan Binish on 2023/07/01.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AppPlugins: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        Localized.self,
        Color.self,
        Image.self
    ]
}
