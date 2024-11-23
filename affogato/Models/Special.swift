//
//  Special.swift
//  affogato
//
//  Created by Kevin ahmad on 30/10/24.
//

import Foundation

struct SpecialsResponse: Decodable {
    let result: [Special]
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case result
        case statusCode = "status_code"
    }
}

struct Special: Decodable, Identifiable {
    var id: Int { itemID }
    let itemID: Int
    let itemName: String
    let latitude: Double
    let longitude: Double
    let category: String
    let subCategory: String?
    let priceRange: String
    let specialties: [String]
    let description: String
    let culturalAuthenticity: String?
    let historicalSignificance: Bool
    let keywordMatchCount: String
    let rating: Double
    let ratingCount: Int
    let vibes: String?
    let ambience: String?
    let images: [String]
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case itemName = "item_name"
        case latitude
        case longitude
        case category
        case subCategory = "sub_category"
        case priceRange = "price_range"
        case specialties
        case description
        case culturalAuthenticity = "cultural_authenticity"
        case historicalSignificance = "historical_significance"
        case keywordMatchCount = "keyword_match_count"
        case rating
        case ratingCount = "rating_count"
        case vibes
        case ambience
        case images
        case distance
    }
}
