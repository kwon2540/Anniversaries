//
//  Created by Maharjan Binish on 2023/07/01.
//

import Foundation
import SwiftUI

@freestanding(expression)
public macro localized(_ key: LocalizedStringResource) -> String = #externalMacro(module: "AppMacros", type: "Localized")

@freestanding(expression)
public macro color(_ key: String) -> Color = #externalMacro(module: "AppMacros", type: "Color")

@freestanding(expression)
public macro image(_ key: String) -> Image = #externalMacro(module: "AppMacros", type: "Image")
