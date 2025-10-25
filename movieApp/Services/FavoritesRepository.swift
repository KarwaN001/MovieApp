//
//  FavoritesRepository.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func toggleFavorite(_ movie: Movie)
    func isFavorite(_ movie: Movie) -> Bool
    func favorites() -> [String]
}

final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let key = "FAVORITE_MOVIE_TITLES"

    private var stored: [String] {
        get { UserDefaults.standard.stringArray(forKey: key) ?? [] }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }

    func toggleFavorite(_ movie: Movie) {
        var list = stored
        if let index = list.firstIndex(of: movie.title) {
            list.remove(at: index)
        } else {
            list.append(movie.title)
        }
        stored = list
    }

    func isFavorite(_ movie: Movie) -> Bool {
        stored.contains(movie.title)
    }

    func favorites() -> [String] {
        stored
    }
}
