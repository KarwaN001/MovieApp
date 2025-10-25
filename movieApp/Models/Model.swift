//
//  Models.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation

struct Movie: Decodable, Equatable {
    let Title: String
    let Year: String
    let Runtime: String?
    let Poster: String?
}

