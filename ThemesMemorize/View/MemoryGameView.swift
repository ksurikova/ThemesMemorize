//
//  ContentView.swift
//  Memorize
//
//  Created by Ksenia Surikova on 05.10.2021.
//

import SwiftUI

struct MemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var regular: Bool { horizontalSizeClass == .regular }
    
    //Mark: body
    var body: some View {
        VStack {
            Text("Memorized \(viewModel.theme.name)").font(.largeTitle)
            AspectVGrid(items: viewModel.model.cards, aspectRatio: UIConstants.aspectRatio, minWidth: UIConstants.minimumCardColumnWidth) {
                
                card in
                CardView(card: card)
                    .onTapGesture{
                        viewModel.choose(card)
                    }
            }.foregroundColor(viewModel.theme.uiViewColor)
            Spacer()
            HStack{
                Button("New game") {
                    viewModel.playAgain()
                }
                Spacer()
                Text("Score: \(viewModel.model.score)").font(.title)
            }
        }.padding(.horizontal)
    }

    struct CardView: View {
        
        let card: MemoryGame<String>.Card
        
        var body: some View {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: UIConstants.cardCornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: UIConstants.cardBorderWidth)
                    Text(card.content).font(.largeTitle)
                } else if card.isMatched {
                    shape.opacity(0)
                }
                else {
                    shape.fill()
                }
            }
            .contentShape(Rectangle())
            .padding(UIConstants.paddingBetweenCards)
        }
    }


    struct MemoryGameView_Previews: PreviewProvider {
        static var previews: some View {
            
            let store = Store()
            MemoryGameView(viewModel: store.gamesByThemes[store.themes[0].id]!)
                .preferredColorScheme(.dark)
            MemoryGameView(viewModel: store.gamesByThemes[store.themes[0].id]!)
                .preferredColorScheme(.light)
        }
        
    }
    
}
