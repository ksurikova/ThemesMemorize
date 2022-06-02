//
//  ColorExtensions.swift
//  Memorize
//
//  Created by Ksenia Surikova on 08.11.2021.
//

import Foundation
import SwiftUI

extension RGBAColor{
    
    init(color: Color) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

extension Color {
    init(rgbaColor: RGBAColor){
        self.init(.sRGB, red: rgbaColor.red, green: rgbaColor.green, blue: rgbaColor.blue, opacity: rgbaColor.alpha)
    }
}


extension GameTheme {
    
    var uiViewColor: Color {
        get { return Color(rgbaColor: self.color) }
        set {self.color = RGBAColor(color: newValue)}
    }
    
    init(name: String, color: Color, numberOfPairsOfCards: Int, emojis: String, id: Int) {
        self.init(name: name, color: RGBAColor(color: color), numberOfPairsOfCards: numberOfPairsOfCards, emojis: emojis, id: id)
    }
}

