//
//  ThemeStore.swift
//  Memorize
//
//  Created by Ksenia Surikova on 08.11.2021.
//

import Foundation
import SwiftUI

class Store: ObservableObject {

    @Published private(set) var themes = [GameTheme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    @Published var editingTheme: GameTheme = GameTheme()
    
    @Published var gamesByThemes : Dictionary<Int, EmojiMemoryGame> = Dictionary<Int, EmojiMemoryGame>()
   
    private var userDefaultsKey: String {"MemoryGameThemeStore"}
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode(Array<GameTheme>.self, from: jsonData) {
            themes = decodedThemes.filter{$0.isValid}
        }
    }
    
    init() {
        restoreFromUserDefaults()
        if themes.isEmpty {
            insertTheme(name: "dolce vita", color: .red, numberOfPairsOfCards: 8, emojis: "๐ถ๐๐ ๐๐ฐ๐ธ๐ผ๐ธ๐ง๐๐๐")
            insertTheme(name: "weather", color: .blue, numberOfPairsOfCards: 7, emojis: "โ๏ธโ๏ธ๐ช๐โ๏ธโก๏ธ๐งโ๏ธ๐ฑโฑ๐")
            insertTheme(name: "animals", color: .green, numberOfPairsOfCards: 11, emojis: "๐ค๐ฆ๐ฆ๐๐ฆง๐ฆฉ๐ฆก๐ฆ๐ฆ๐๐๐จ")
            insertTheme(name: "people", color: .pink, numberOfPairsOfCards: 9, emojis: "๐คก๐ค ๐ถ๐ฝ๐ฎ๐ฟโโ๏ธ๐จ๐ผโ๐ป๐ง๐ฝโโ๏ธ๐ฅท๐ป๐จ๐พโ๐จ๐๐ป๐๐ฝโโ๏ธ๐ฉโ๐ง๐บ")
            insertTheme(name: "activity", color: .purple, numberOfPairsOfCards: 8, emojis: "๐ง๐ปโโ๏ธโธ๐๐โท๐คธ๐ฟโโ๏ธ๐ด๐ผโโ๏ธ๐ฏโ๐ค๐๐๐พโโ๏ธ")
            insertTheme(name: "meal", color: .yellow, numberOfPairsOfCards: 10, emojis: "๐๐ฅ๐ฅก๐ซ๐ฅ๐๐ฅ๐ฝ๐ง๐ฅซ๐ข๐")
        }
        gamesByThemes = Dictionary(uniqueKeysWithValues:  themes.map{ ($0.id, try! EmojiMemoryGame(with: themes[$0])) })
    }
    
    func theme(at index: Int) -> GameTheme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    //Mark: - Intent(s)
    func insertTheme(name: String, color: Color, numberOfPairsOfCards: Int, emojis: String, at index: Int = 0) {
        let unique: Int = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = GameTheme(name: name, color: color, numberOfPairsOfCards: numberOfPairsOfCards, emojis: emojis, id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
        gamesByThemes[theme.id] = try! EmojiMemoryGame(with: theme)
    }
    
    
    func insertThemeIfValid(_ theme: GameTheme) {
        if theme.isValid {
            insertTheme(name: theme.name, color: theme.uiViewColor, numberOfPairsOfCards: theme.numberOfPairsOfCards, emojis: theme.emojis)
        }
    }
    

    func saveThemeIfValid() {
        // insert new theme
        if editingTheme.id == GameTheme.temporaryId {
            insertThemeIfValid(editingTheme)
        }
        else {
            let editedTheme = themes.filter{$0.id == editingTheme.id}
            if editedTheme.count == 1, editingTheme.isValid {
                themes[editedTheme[0]] = editingTheme
                gamesByThemes[editingTheme.id] = try! EmojiMemoryGame(with: editingTheme)
            }
        }
    }
    
    func removeTheme(atOffsets: IndexSet){
        themes.remove(atOffsets: atOffsets)
    }

}
