//
//  ServiceStatus.swift
//  affogato
//
//  Created by Kevin ahmad on 21/10/24.
//

import Foundation

struct ServiceStatus: Decodable {
    let status: String
}

struct SearchResponse: Decodable {
    let results: [String]
}
