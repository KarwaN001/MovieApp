//
//  MovieDetailsViewModel.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieDetailsViewModel {
    // Inputs
    private let favoritesRepo: FavoritesRepositoryProtocol

    // Outputs
    let title: Driver<String>
    let year: Driver<String>
    let runtime: Driver<String>
    let poster: Driver<String>
    let isFavorite: BehaviorRelay<Bool>

    private let movie: Movie
    private let disposeBag = DisposeBag()

    init(movie: Movie, favoritesRepo: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.movie = movie
        self.favoritesRepo = favoritesRepo

        title = Driver.just(movie.title)
        year = Driver.just(movie.year)
        runtime = Driver.just(movie.runtime ?? "")
        poster = Driver.just(movie.poster ?? "")
        isFavorite = BehaviorRelay(value: favoritesRepo.isFavorite(movie))
    }

    func toggleFavorite() {
        favoritesRepo.toggleFavorite(movie)
        isFavorite.accept(favoritesRepo.isFavorite(movie))
    }

    func trailerURL() -> URL? {
        // simple YouTube search query
        let encoded = movie.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://www.youtube.com/results?search_query=\(encoded)+trailer")
    }
}
