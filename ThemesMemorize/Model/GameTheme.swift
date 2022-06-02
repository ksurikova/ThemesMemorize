//
//  MemoryGameTheme.swift
//  Memorize
//
//  Created by Ksenia Surikova on 11.10.2021.
//

import Foundation

struct RGBAColor: Codable {
    private(set) var red: Double
    private(set) var green: Double
    private(set) var blue: Double
    private(set) var alpha: Double
    
    init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}


struct GameTheme: Identifiable, Codable, Hashable  {
    
    static let minimumPairsOfCards = 2
    static let temporaryId = 0
    static let sampleName = "new"
    static let sampleColor = RGBAColor(color: .white)
    
    enum ThemeValidationError: Error {
        case NoEnoughEmojis
        case NoEnoughNumberOfPairsOfCards
        case NoEnoughEmojisForNumberOfPairsOfCards
    }

    
    var name: String
    var color: RGBAColor
    var numberOfPairsOfCards: Int
    {
        didSet {
            isValid = checkIsValid()
        }
    }
    var emojis: String   {
        didSet {
            canSetNumberOfPairsOfCards = checkCanSetNumberOfPairsOfCards()
            if canSetNumberOfPairsOfCards {
                if numberOfPairsOfCards > emojis.count {
                    numberOfPairsOfCards = emojis.count
                }
            } else {
                numberOfPairsOfCards = GameTheme.minimumPairsOfCards
            }
            // theme valid value can be changed there, so update it
            isValid = checkIsValid()
        }
    }
    
    var defaultEmoji: String {
        get {emojis.isEmpty ? "" : String(emojis.first!)}
    }
    
    let id: Int
    
    // can't define it as computed values, because that case we won't be notified about changes of properties
    private(set) var isValid: Bool = false
    private(set) var canSetNumberOfPairsOfCards: Bool = false
   
    init(name: String, color: RGBAColor, numberOfPairsOfCards: Int, emojis: String, id: Int) {
        let rightEmojis = GameTheme.getOnlyUniqueEmojis(from: emojis)
        self.name = name
        self.color = color
        self.numberOfPairsOfCards = numberOfPairsOfCards
        self.emojis = rightEmojis
        self.id = id
        canSetNumberOfPairsOfCards = checkCanSetNumberOfPairsOfCards()
        isValid = checkIsValid()
    }
    
    
    init() {
        self.name = GameTheme.sampleName
        self.color = GameTheme.sampleColor
        self.numberOfPairsOfCards = GameTheme.minimumPairsOfCards
        self.emojis = ""
        self.id = GameTheme.temporaryId
        canSetNumberOfPairsOfCards = checkCanSetNumberOfPairsOfCards()
        isValid = checkIsValid()
    }
    
   
    static func getOnlyUniqueEmojis(from string: String) -> String {
        return string.filter { $0.isEmoji }
        .removingDuplicateCharacters
    }

    
    private func checkCanSetNumberOfPairsOfCards() -> Bool {
       return emojis.count >= GameTheme.minimumPairsOfCards
   }
   
   private func checkIsValid() -> Bool {
       return checkCanSetNumberOfPairsOfCards() && numberOfPairsOfCards >= GameTheme.minimumPairsOfCards &&  emojis.count >= numberOfPairsOfCards
   }
   
    
    //Mark: Equatable, Hashable
    static func == (lhs: GameTheme, rhs: GameTheme) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
