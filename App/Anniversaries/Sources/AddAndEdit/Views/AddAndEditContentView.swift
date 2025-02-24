//
//  Created by クォン ジュンヒョク on 2023/11/12.
//

import SwiftUI
import ComposableArchitecture
import CoreKit
import AppUI

struct AddAndEditContentView: View {
    @FocusState var focusedField: AddAndEdit.State.Field?
    
    @Bindable var store: StoreOf<AddAndEdit>

    var body: some View {
        Form {
            Section {
                Picker(#localized("Kind"), selection: $store.selectedKind) {
                    ForEach(AnniversaryKind.allCases, id: \.self) { kind in
                        Text(kind.title).tag(kind)
                    }
                }
                if case .others = store.selectedKind {
                    LabeledContent(#localized("Title")) {
                        TextField("", text: $store.othersTitle)
                            .focused($focusedField, equals: .title)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            Section {
                LabeledContent(#localized("Name")) {
                    TextField("", text: $store.name)
                        .focused($focusedField, equals: .name)
                        .multilineTextAlignment(.trailing)
                }
                    
                DatePicker(
                    #localized("Date"),
                    selection: $store.date,
                    in: ...Date.now,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .tint(#color("tint"))
            }
            Section {
                LabeledContent(#localized("Remind")) {
                    if store.reminds.count < 5 {
                        Button {
                            store.send(.addRemindButtonTapped)
                            // +タップしたらモーダルでDateとTimeとRepeatを決める画面を表示する
                            // 全てToggleでOn/OffできるようにしてDefaultはDateはOn、TimeはOff
                            // RepeatはDefaultはOnで下に毎年リマインドすることを案内し
                            // 次リマインドする年月日を表示する
                            // 全体的にRemindアプリを参考する
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }

                ForEach(store.reminds, id: \.self) { remind in
                    Button {
                        store.send(.remindTapped(remind))
                    } label: {
                        HStack {
                            Text(remind.date.formatted(.remindDate))
                                .padding(.leading, 8)
                            
                            Spacer()
                            
                            if remind.isRepeat {
                                TagView(type: .repeat)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    store.send(.deleteRemind(indexSet))
                }
            }
            Section {
                TextField(#localized("Memo"), text: $store.memo, axis: .vertical)
                    .frame(height: 100, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)
                    .focused($focusedField, equals: .memo)
                    .background {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusedField = .memo
                            }
                    }
            }
        }
        .tint(#color("#000000"))
        .padding(.top, -24)
        .bind($store.focusedField, to: self.$focusedField)
        .overlay {
            if store.focusedField != nil {
                dismissKeyboardView
            }
        }
    }

    private var dismissKeyboardView: some View {
        Color.clear
            .contentShape(Rectangle())
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                store.send(.dismissKeyboardViewTapped)
            }
    }
}
