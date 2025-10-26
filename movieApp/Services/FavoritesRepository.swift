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
    func favorites() -> [Movie]
}

final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let key = "FAVORITE_MOVIES"

    private var stored: [Movie] {
        get {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
                return []
            }
            return movies
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: key)
            }
        }
    }

    func toggleFavorite(_ movie: Movie) {
        var list = stored
        if let index = list.firstIndex(where: { $0.Title == movie.Title }) {
            list.remove(at: index)
        } else {
            list.append(movie)
        }
        stored = list
    }

    func isFavorite(_ movie: Movie) -> Bool {
        stored.contains(where: { $0.Title == movie.Title })
    }

    func favorites() -> [Movie] {
        stored
    }
}
