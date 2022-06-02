//
//  AspectVGrid.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    
    var items: [Item]
    var aspectRatio: CGFloat
    var minWidth: CGFloat
    var content : (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, minWidth: CGFloat, @ViewBuilder content : @escaping (Item) -> ItemView){
        self.items = items
        self.aspectRatio = aspectRatio
        self.minWidth = minWidth
        self.content = content
    }
    
    
    var body: some View {
        // GeometryReader must be flexible, but we calculate in it directly in LazyVGrid (size depepends on Items!)
        // so add VStack (flexible) - don't lose that property
        GeometryReader {geometry in
            VStack {
                let width: CGFloat = widthThatFitsOrEqualMinWidth(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio, minWidth: minWidth)
                ScrollView {
                    LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0){
                        ForEach(items) {
                            item in content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
    }
}

private func adaptiveGridItem(width: CGFloat) -> GridItem {
    var gridItem = GridItem(.adaptive(minimum: width))
    gridItem.spacing = 0
    return gridItem
}

private func widthThatFitsOrEqualMinWidth(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat, minWidth: CGFloat) -> CGFloat {
    var columnCount = 1
    var rowCount = itemCount
    repeat {
        let itemWidth = size.width / CGFloat(columnCount)
        if itemWidth < minWidth {
            return minWidth
        }
        let itemHeight = itemWidth / itemAspectRatio
        if CGFloat(rowCount) * itemHeight < size.height {
            break
        }
        columnCount+=1
        rowCount = (itemCount + (columnCount - 1 )) / columnCount
    } while columnCount < itemCount
                if columnCount > itemCount {
        columnCount = itemCount
    }
    return floor(size.width / CGFloat(columnCount))
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}


