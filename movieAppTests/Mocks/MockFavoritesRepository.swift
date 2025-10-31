//
//  MockFavoritesRepository.swift
//  movieAppTests
//
//  Created by Karwan on 31/10/2025.
//

import Foundation
@testable import movieApp

/// Mock implementation of FavoritesRepository for testing ViewModels
final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    
    // MARK: - Properties
    private var favoriteMovies: [Movie] = []
    var toggleFavoriteCallCount = 0
    var isFavoriteCallCount = 0
    var favoritesCallCount = 0
    
    // MARK: - FavoritesRepositoryProtocol
    func toggleFavorite(_ movie: Movie) {
        toggleFavoriteCallCount += 1
        
        if let index = favoriteMovies.firstIndex(where: { $0.title == movie.title }) {
            favoriteMovies.remove(at: index)
        } else {
            favoriteMovies.append(movie)
        }
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        isFavoriteCallCount += 1
        return favoriteMovies.contains(where: { $0.title == movie.title })
    }
    
    func favorites() -> [Movie] {
        favoritesCallCount += 1
        return favoriteMovies
    }
    
    // MARK: - Helper Methods
    func reset() {
        favoriteMovies = []
        toggleFavoriteCallCount = 0
        isFavoriteCallCount = 0
        favoritesCallCount = 0
    }
    
    func setFavorites(_ movies: [Movie]) {
        favoriteMovies = movies
    }
}

