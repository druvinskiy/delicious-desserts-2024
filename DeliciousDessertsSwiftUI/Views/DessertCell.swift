//
//  DessertCell.swift
//  DeliciousDessertsSwiftUI
//
//  Created by David Ruvinskiy on 6/27/24.
//

import SwiftUI

struct DessertCell: View {
    let dessert: Dessert
    
    let nameViewHeightMultiplier: CGFloat = 0.15
    
    var body: some View {
            AsyncImage(url: URL(string: dessert.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                Image("dessert-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }.overlay(alignment: .topLeading) {
                Text(dessert.name)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .tint(.white)
                    .padding(5)
                    .background(.thinMaterial)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding([.top, .leading], 5)
            }
    }
}
