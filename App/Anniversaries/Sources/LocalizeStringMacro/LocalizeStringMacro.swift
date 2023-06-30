//
//  Created by Maharjan Binish on 2023/06/30.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LocalizeMacro: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "String(localized: \(argument), bundle: .appUI)"
    }
}

@main
struct LocalizePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LocalizeMacro.self,
    ]
}
