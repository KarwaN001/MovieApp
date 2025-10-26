//
//  FavoritesViewModel.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoritesViewModel {
    private let favoritesRepo: FavoritesRepositoryProtocol
    let favoriteMovies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])

    init(favoritesRepo: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.favoritesRepo = favoritesRepo
        loadFavorites()
    }

    func loadFavorites() {
        let movies = favoritesRepo.favorites()
        favoriteMovies.accept(movies)
    }

    func removeFavorite(_ movie: Movie) {
        favoritesRepo.toggleFavorite(movie)
        loadFavorites()
    }
}
