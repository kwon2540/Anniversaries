//
//  Created by マハルジャン ビニシュ on 2024/02/25.
//

import SwiftUI

public struct TagView: View {
    public enum `Type` {
        case remind
        case memo
        case `repeat`
        
        var title: String {
            switch self {
            case .remind: #localized("Remind")
            case .memo: #localized("Memo")
            case .repeat: #localized("Repeat")
            }
        }
    }
    
    public init(type: Type) {
        self.type = type
    }
    
    private var type: Type
    
    public var body: some View {
        Text(type.title)
            .font(.caption2)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .border(.black, width: 1)
            .clipShape(RoundedRectangle(cornerRadius: 2))
    }
}

#Preview {
    TagView(type: .repeat)
}
