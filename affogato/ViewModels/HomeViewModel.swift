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
    @Published var searchText: String = ""
    @Published var errorMessage: String?
    @Published var isSearching = false
    @Published var searchResults: [Special] = []

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
    
    var filteredSpecials: [Special] {
        if searchText.isEmpty {
            return specials
        } else {
            return specials.filter { $0.itemName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func performSearch() {
        guard !searchText.isEmpty else {
            // If search text is empty, revert to showing specials
            isSearching = false
            searchResults = []
            return
        }

        isSearching = true
        apiService.search(query: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    // Decode search results
                    do {
                        let decodedResponse = try JSONDecoder().decode(SpecialsResponse.self, from: data)
                        self?.searchResults = decodedResponse.result
                    } catch {
                        self?.errorMessage = error.localizedDescription
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
