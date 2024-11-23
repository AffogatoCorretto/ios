//
//  PostViewModel.swift
//  affogato
//
//  Created by Kevin ahmad on 06/10/24.
//

import SwiftUI

class PostViewModel: ObservableObject {
    @Published var title: String = ""
    // Add more properties for post creation
    
    var isValid: Bool {
        !title.isEmpty // Add more validation as needed
    }
    
    func createPost() {
        // Implement post creation logic
        print("Creating post: \(title)")
    }
}
