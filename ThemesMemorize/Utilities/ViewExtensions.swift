//
//  ViewExtensions.swift
//  Memorize
//
//  Created by Ksenia Surikova on 13.11.2021.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func wrappedInNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            NavigationView {
                self
                    .navigationBarTitleDisplayMode(.inline)
                    .dismissable(dismiss)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            self
        }
    }
    
    // convenience function to make an iPhone sheet or popover dismissable
    // assumes there is a toolbar available to hold the Close button
    @ViewBuilder
    func dismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            self.toolbar {
                // note .cancellationAction placement of the Close button
                // SwiftUI will put it in the appropriate spot in some toolbar somewhere
                // (might depend on what toolbars exist and on the platform we're on)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        } else {
            self
        }
    }
}
