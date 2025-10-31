//
//  Models.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation

struct Movie: Codable, Equatable {
    let title: String
    let year: String
    let runtime: String?
    let poster: String?
    
    // Map JSON keys (Title, Year, etc.) to Swift properties (title, year, etc.)
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case runtime = "Runtime"
        case poster = "Poster"
    }
}

