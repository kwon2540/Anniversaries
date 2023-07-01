//
//  Created by Maharjan Binish on 2023/07/01.
//

import Foundation

@freestanding(expression)
public macro localized(_ key: LocalizedStringResource) -> String = #externalMacro(module: "AppMacros", type: "Localized")
