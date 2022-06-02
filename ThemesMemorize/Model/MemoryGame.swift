//
//  MemoryGame.swift
//  Memorize
//
//  Created by Ksenia Surikova on 08.10.2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    
    let penaltyPoint = 1
    let winPoint = 2
    
    private(set) var cards: Array<Card>
    private var indexOfTheAndOnlyFaceUpCard: Int?
    private(set) var score: Int = 0
    
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            
            if let potentialMatchIndex = indexOfTheAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score = score + winPoint
                }
                // каждая ранее просмотренная, которая участвует в несовпадении
                else {
                    if cards[chosenIndex].isAlreadySeen {
                        score = score - penaltyPoint
                    }
                    if cards[potentialMatchIndex].isAlreadySeen {
                        score = score - penaltyPoint
                    }
                }
                indexOfTheAndOnlyFaceUpCard = nil
            }
            else{
                for index in cards.indices {
                    if cards[index].isFaceUp {
                        cards[index].isAlreadySeen = true
                    }
                    cards[index].isFaceUp = false
                }
                indexOfTheAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
   
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        // add numberOfPairsOfCards * 2
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards = cards.shuffled()
    }
    
    struct Card : Identifiable {
       
        var isFaceUp : Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        var isAlreadySeen: Bool = false
    }
   
}
