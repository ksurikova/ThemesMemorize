//
//  ThemeChooserView.swift
//  Memorize
//
//  Created by Ksenia Surikova on 08.11.2021.
//

import SwiftUI


struct ThemeChooserView: View {

    @EnvironmentObject var store: Store
    
    @State private var showEditThemeSheet = false
    
    // we inject a Binding to this in the environment for the List and EditButton
    // using the \.editMode in EnvironmentValues
    @State private var editMode: EditMode = .inactive
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var regular: Bool { horizontalSizeClass == .regular }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    // tapping on this row in the List will navigate to a MemoryGameView
                    NavigationLink(destination: MemoryGameView(viewModel: store.gamesByThemes[theme.id]!)
                    ){
                        VStack(alignment: .leading) {
                            Text(theme.name)
                            HStack() {
                                Text("\(theme.numberOfPairsOfCards) pairs of cards like \(theme.defaultEmoji)").layoutPriority(100)
                                Spacer()
                                if regular {
                                    Text("Shirt color:").layoutPriority(100)
                                }
                                Rectangle()
                                    .strokeBorder(UIConstants.colorBorderTheme, lineWidth: UIConstants.cardBorderWidth)
                                    .background(Rectangle().fill(theme.uiViewColor))
                                    .frame(maxWidth: UIConstants.colorBlockMaxWidth).layoutPriority(0)
                            }
                        }
                        .contentShape(Rectangle())
                        // tapping when NOT in editMode will follow the NavigationLink
                        // (that's why gesture is set to nil in that case)
                        .gesture(editMode == .active ?
                                 tap(selected: theme)
                                 : nil)
                    }
                }
                // teach the ForEach how to delete items
                // at the indices in indexSet from its array
                .onDelete { indexSet in
                    store.removeTheme(atOffsets: indexSet)
                }
            }
            .navigationTitle("Theme chooser")
            .navigationBarTitleDisplayMode(.inline)
            // add an EditButton on the trailing side of our NavigationView
            // and a Close button on the leading side
            // notice we are adding this .toolbar to the List
            // (not to the NavigationView)
            // (NavigationView looks at the View it is currently showing for toolbar info)
            // (ditto title and titledisplaymode above)
            .toolbar() {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    if editMode == .inactive {
                        Button(action: {
                            store.editingTheme = GameTheme()
                            showEditThemeSheet = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            // see comment for editMode @State above
            .environment(\.editMode, $editMode)
            
            .sheet(isPresented: $showEditThemeSheet) {
                ThemeEditor()
                // make this sheet dismissable with a Close button on iPhone
                    .wrappedInNavigationViewToMakeDismissable { showEditThemeSheet = false }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    func tap(selected: GameTheme) -> some Gesture {
        TapGesture().onEnded {
            store.editingTheme = selected
            showEditThemeSheet = true
        }
    }
}



struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooserView()
            .environmentObject(Store())
            .previewDevice("iPad Pro (12.9-inch)")
    }
}
