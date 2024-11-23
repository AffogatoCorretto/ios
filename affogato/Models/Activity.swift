//
//  Activity.swift
//  affogato
//
//  Created by Kevin ahmad on 06/10/24.
//

import SwiftUI

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let images: [String]
    let color: Color
    let height: CGFloat
    
    init(title: String, images: [String], color: Color) {
        self.title = title
        self.images = images
        self.color = color
        self.height = CGFloat(200)
    }
}
