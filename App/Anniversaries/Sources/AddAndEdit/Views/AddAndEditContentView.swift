//
//  Created by クォン ジュンヒョク on 2023/11/12.
//

import SwiftUI
import ComposableArchitecture
import CoreKit
import AppUI

struct AddAndEditContentView: View {
    @FocusState var focusedField: AddAndEdit.State.Field?
    
    var viewStore: ViewStoreOf<AddAndEdit>

    var body: some View {
        Form {
            Section {
                Picker(#localized("Kind"), selection: viewStore.$selectedKind) {
                    ForEach(AnniversaryKind.allCases, id: \.self) { kind in
                        Text(kind.title).tag(kind)
                    }
                }
                if case .others = viewStore.selectedKind {
                    TextField(#localized("Title"), text: viewStore.$othersTitle)
                        .focused($focusedField, equals: .title)
                }
            }
            Section {
                TextField(#localized("Name"), text: viewStore.$name)
                    .focused($focusedField, equals: .name)
                    
                DatePicker(
                    #localized("Date"),
                    selection: viewStore.$date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
            }
            Section {
                LabeledContent(#localized("Remind")) {
                    Button {
                        viewStore.send(.addRemindButtonTapped)
                        // +タップしたらモーダルでDateとTimeとRepeatを決める画面を表示する
                        // 全てToggleでOn/OffできるようにしてDefaultはDateはOn、TimeはOff
                        // RepeatはDefaultはOnで下に毎年リマインドすることを案内し
                        // 次リマインドする年月日を表示する
                        // 全体的にRemindアプリを参考する
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ForEach(viewStore.reminds, id: \.self) { remind in
                    Text(remind.date.formatted())
                        .padding(.leading, 8)
                }
                .onDelete { indexSet in
                    viewStore.send(.deleteRemind(indexSet))
                }
            }
            Section {
                TextField(#localized("Memo"), text: viewStore.$memo)
                    .frame(height: 100, alignment: .top)
            }
        }
        .padding(.top, -24)
        .bind(viewStore.$focusedField, to: self.$focusedField)
    }
}
