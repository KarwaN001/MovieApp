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
        // We only stored movie titles, so we’ll rebuild fake Movie models here for now
        let titles = favoritesRepo.favorites()
        let movies = titles.map { Movie(title: $0, year: "", runtime: "", poster: nil) }
        favoriteMovies.accept(movies)
    }

    func removeFavorite(_ movie: Movie) {
        favoritesRepo.toggleFavorite(movie)
        loadFavorites()
    }
}
