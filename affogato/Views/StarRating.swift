//
//  StarRating.swift
//  affogato
//
//  Created by Kevin ahmad on 30/10/24.
//

import SwiftUI

struct StarRating: View {
    let rating: Double
    let maxRating: Int
    let fontSize: CGFloat
    let showRatingCount: Bool
    let ratingCount: Int?
    let color: Color
    
    init(
        rating: Double,
        maxRating: Int = 5,
        fontSize: CGFloat = 12,
        showRatingCount: Bool = true,
        ratingCount: Int? = nil,
        color: Color = .yellow
    ) {
        self.rating = rating
        self.maxRating = maxRating
        self.fontSize = fontSize
        self.showRatingCount = showRatingCount
        self.ratingCount = ratingCount
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 2) {
            starsView
            if showRatingCount, let count = ratingCount {
                ratingCountView(count)
            }
        }
    }
    
    private var starsView: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .foregroundColor(color)
                    .font(.system(size: fontSize))
            }
        }
    }
    
    private func starType(for index: Int) -> String {
        if Double(index) < floor(rating) {
            return "star.fill"
        } else if Double(index) < ceil(rating) {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
    
    private func ratingCountView(_ count: Int) -> some View {
        Text("(\(count))")
            .font(.system(size: fontSize))
            .foregroundColor(.gray)
            .padding(.leading, 4)
    }
}

// Preview provider for design iteration
struct StarRating_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            StarRating(rating: 4.5, ratingCount: 123)
            StarRating(rating: 3.7, fontSize: 16, ratingCount: 45)
            StarRating(rating: 2.5, fontSize: 20, showRatingCount: false)
            StarRating(rating: 5.0, ratingCount: 89, color: .orange)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
