//
//  Created by クォン ジュンヒョク on 2023/05/27.
//

import AppUI
import ComposableArchitecture
import SwiftUI

private extension Anniversary.State.Mode {
    var title: String {
        switch self {
        case .new:
            return #localized("New")
        case .edit:
            return #localized("Edit")
        }
    }

    var completeTitle: String {
        switch self {
        case .new:
            return #localized("Add")
        case .edit:
            return #localized("Done")
        }
    }
}

public struct AnniversaryView: View {
    struct Remind: Identifiable {
        let id = UUID()
        @Binding var date: Date
    }

    enum Kind {
        case birth
        case marriage
        case death
        case other
    }

    public init(store: StoreOf<Anniversary>) {
        self.store = store
    }

    private var store: StoreOf<Anniversary>

    @State private var selectedKind: Kind = .birth
    @State private var date = Date()
    @State private var reminds: [Remind] = []
    @State private var bool = false

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    Section {
                        Picker("Kind", selection: $selectedKind) {
                            Text("birth").tag(Kind.birth)
                            Text("marriage").tag(Kind.marriage)
                            Text("death").tag(Kind.death)
                            Text("other").tag(Kind.other)
                        }
                        if case .other = selectedKind {
                            TextField("Title", text: .constant(""))
                        }
                    }
                    Section {
                        TextField("Name", text: .constant(""))
                        DatePicker(
                            "Date",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)
                    }
                    Section {
                        LabeledContent("Remind") {
                            Button {
                                reminds.append(.init(date: .constant(.now)))
                                // +タップしたらモーダルでDateとTimeとRepeatを決める画面を表示する
                                // 全てToggleでOn/OffできるようにしてDefaultはDateはOn、TimeはOff
                                // RepeatはDefaultはOnで下に毎年リマインドすることを案内し
                                // 次リマインドする年月日を表示する
                                // 全体的にRemindアプリを参考する
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        ForEach(reminds) { remind in
                            DatePicker(
                                "",
                                selection: remind.$date,
                                in: .now...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                        }
                    }
                    Section {
                        TextField("Memo", text: .constant(""))
                            .frame(height: 100, alignment: .top)
                    }
                }
                .navigationTitle(viewStore.mode.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(#localized("Cancel")) {
                            viewStore.send(.cancelButtonTapped)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(viewStore.mode.completeTitle) {
                            viewStore.send(.completeButtonTapped)
                        }
                    }
                }
            }
        }
    }
}

struct AnniversaryView_Previews: PreviewProvider {
    static var previews: some View {
        AnniversaryView(store: .init(initialState: .init(mode: .new), reducer: Anniversary()))
            .previewDisplayName("New")
        AnniversaryView(store: .init(initialState: .init(mode: .edit), reducer: Anniversary()))
            .previewDisplayName("Edit")
    }
}
