//
//  StackedImagesCard.swift
//  affogato
//
//  Created by Kevin ahmad on 30/10/24.
//

import SwiftUI

struct StackedImagesCard: View {
    let imageUrl: String
    let title: String
    let rating: Double
    let ratingCount: Int

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Image as the card background
            RemoteImageView(url: URL(string: imageUrl))
                .aspectRatio(3/4, contentMode: .fill) // Portrait aspect ratio
                .frame(width: 180, height: 240) // Adjust as needed
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1) // Subtle border
                )
                .clipped()

            // Gradient shading behind the text
            LinearGradient(
                colors: [Color.black.opacity(0.7), Color.black.opacity(0.3), Color.clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(height: 80) // Dark shading height

            // Text content overlay
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Text("⭐️")
                        .font(.footnote)
                        .padding(4)
//                        .background(Circle().fill(Color.yellow.opacity(0.8)))

                    Text("\(rating, specifier: "%.1f") (\(ratingCount))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(12) // Padding for the text block
        }
        .frame(width: 180, height: 240) // Card size
    }
}
