//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ksenia Surikova on 08.10.2021.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {
    
    enum EmojiMemoryGameError : Error {
        case NoValidThemeForGame
    }
    

    static func createMemoryGame(with theme: GameTheme) -> MemoryGame<String> {
        let currentEmojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) {pairIndex in String(currentEmojis[pairIndex]) }
    }
    
    
    @Published private(set) var model: MemoryGame<String>
    private(set) var theme: GameTheme
    
    init(with theme: GameTheme) throws {
        guard theme.isValid else {throw EmojiMemoryGameError.NoValidThemeForGame}
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
    //Mark: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card) {
        // don't need more, because we set @Published directive to model var
        //objectWillChange.send()
        model.choose(card)
    }
    
    func playAgain() {
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
   
}
