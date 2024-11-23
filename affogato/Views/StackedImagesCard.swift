//
//  StackedImagesCard.swift
//  affogato
//
//  Created by Kevin ahmad on 30/10/24.
//

import SwiftUI

struct StackedImagesCard: View {
    let images: [String]
    let maxStacked: Int = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // If we have 3 images, show the left-tilted card
                if images.count > 2, let thirdImageUrl = URL(string: images[2]) {
                    RemoteImageView(url: thirdImageUrl)
                        .frame(width: geometry.size.width - 20, height: geometry.size.height - 10)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .rotationEffect(.degrees(-6))
                        .offset(x: -5)
                        .zIndex(1)
                }
                
                // If we have 2 or more images, show the right-tilted card
                if images.count > 1, let secondImageUrl = URL(string: images[1]) {
                    RemoteImageView(url: secondImageUrl)
                        .frame(width: geometry.size.width - 20, height: geometry.size.height - 10)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .rotationEffect(.degrees(6))
                        .offset(x: 5)
                        .zIndex(2)
                }
                
                // Main/front card always centered
                if let firstImageUrl = URL(string: images[0]) {
                    RemoteImageView(url: firstImageUrl)
                        .frame(width: geometry.size.width - 10, height: geometry.size.height)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .zIndex(3)
                }
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .frame(height: 130) // Reduced overall height
    }
}

