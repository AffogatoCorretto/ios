//
//  ServiceStatusViewModel.swift
//  affogato
//
//  Created by Kevin ahmad on 21/10/24.
//


import Foundation
import Combine

class ServiceStatusViewModel: ObservableObject {
    @Published var status: String = ""
    @Published var searchResults: [String] = []
    @Published var errorMessage: String = ""
    @Published var specialsResults: [String] = [] // To store specials results

    private var apiService: APIService
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func fetchServiceStatus() {
        apiService.fetchServiceStatus { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    self?.status = status
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
//    func fetchSpecials() { // Removed 'query' parameter
//        apiService.fetchSpecials { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        self?.specialsResults = [jsonString] // Display raw JSON
//                    } else {
//                        self?.errorMessage = "Failed to decode specials."
//                    }
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }

    func performSearch(query: String) {
        apiService.search(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        self?.searchResults = [jsonString] 
                    } else {
                        self?.errorMessage = "Failed to decode search results."
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
