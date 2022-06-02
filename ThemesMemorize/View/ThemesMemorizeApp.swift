//
//  ThemesMemorizeApp.swift
//  ThemesMemorize
//
//  Created by Ksenia Surikova on 02.06.2022.
//

import SwiftUI

@main
struct ThemesMemorizeApp: App {
    @StateObject var themeStore =  Store()
    
    var body: some Scene {
        WindowGroup {
            ThemeChooserView()
                .environmentObject(themeStore)
        }
    }
}
