//
//  Models.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation

struct Movie: Decodable, Equatable {
    let title: String
    let year: String
    let runtime: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case runtime = "Runtime"
        case poster = "Poster"
    }
}

