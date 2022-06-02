//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Ksenia Surikova on 09.11.2021.
//

import SwiftUI

struct ThemeEditor: View {
    
    @EnvironmentObject var store: Store
    
    @State private var emojisToAdd = ""
    @ScaledMetric var emojiFontSize: CGFloat = UIConstants.defaultFontSize
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        Form {
            nameSection
            colorSection
            addEmojisSection
            removeEmojiSection.layoutPriority(100)
            if  store.editingTheme.canSetNumberOfPairsOfCards {
                stepperSection
            }
            Button("Save") {
                store.saveThemeIfValid()
                self.presentationMode.wrappedValue.dismiss()
            }
            .disabled(!store.editingTheme.isValid)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            emojisToAdd = ""
        }
    }
    
    
    var colorSection: some View {
        Section(header: Text("Shirt card color")) {
            ColorPicker("", selection: $store.editingTheme.uiViewColor).labelsHidden()
        }
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $store.editingTheme.name)
        }
    }
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
                .font(.system(size: emojiFontSize))
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            store.editingTheme.emojis = GameTheme.getOnlyUniqueEmojis(from: emojis +  store.editingTheme.emojis)
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji"), footer: Text("Need to leave \(GameTheme.minimumPairsOfCards) emojis at least").foregroundColor(.red)) {
            let emojis = store.editingTheme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: UIConstants.minimumEmojiColumnWidth))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                store.editingTheme.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: emojiFontSize))
        }
    }
    
    var stepperSection: some View {
        Section(header: Text("Select number of pairs of cards")) {
            Stepper("\(store.editingTheme.numberOfPairsOfCards)", value: $store.editingTheme.numberOfPairsOfCards, in: GameTheme.minimumPairsOfCards...store.editingTheme.emojis.count)
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        let themeStore = Store()
        ThemeEditor()
            .environmentObject(themeStore)
            .previewLayout(.fixed(width: 300, height: 800))
    }
    
}
