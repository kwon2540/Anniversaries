//
//  Created by Maharjan Binish on 2023/06/30.
//

import Foundation


@freestanding(expression)
public macro localize(_ key: LocalizedStringResource) -> String = #externalMacro(module: "LocalizeStringMacro", type: "LocalizeMacro")
