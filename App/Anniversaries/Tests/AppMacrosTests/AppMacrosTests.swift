//
//  Created by Maharjan Binish on 2023/07/01.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

//TODO: Find the reason for the importable macro module
//import AppMacros
//
//let testMacros: [String: Macro.Type] = [
//    "localized": Localized.self,
//    "color": Color.self
//]
//
//final class AppMacroTests: XCTestCase {
//    func test_Localized() {
//        assertMacroExpansion(
//            """
//            #localized("Anniversaries")
//            """,
//            expandedSource: """
//            String(localized: "Anniversaries, bundle: .appUI")
//            """,
//            macros: testMacros
//        )
//    }
//
//    func test_Color() {
//        assertMacroExpansion(
//            """
//            #color("dark_blue")
//            """,
//            expandedSource: """
//            Color("dark_blue, bundle: .appUI")
//            """,
//            macros: testMacros
//        )
//    }
//}
