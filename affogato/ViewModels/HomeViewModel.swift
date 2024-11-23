//
//  HomeViewModel.swift
//  affogato
//
//  Created by Kevin ahmad on 06/10/24.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var specials: [Special] = []
    @Published var errorMessage: String?

    private var apiService: APIService
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
        fetchSpecials()
    }
    
    func fetchSpecials() {
        apiService.fetchSpecials { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let specials):
                    self?.specials = specials
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
