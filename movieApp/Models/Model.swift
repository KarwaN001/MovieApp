//
//  Models.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation

struct Movie: Decodable, Equatable {
    let id: String
    let title: String
    let year: String
    let type: String
    let posterURL: String

    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case posterURL = "Poster"
    }
}
