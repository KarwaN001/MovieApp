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

        title = Driver.just(movie.Title)
        year = Driver.just(movie.Year)
        runtime = Driver.just(movie.Runtime ?? "")
        poster = Driver.just(movie.Poster ?? "")
        isFavorite = BehaviorRelay(value: favoritesRepo.isFavorite(movie))
    }

    func toggleFavorite() {
        favoritesRepo.toggleFavorite(movie)
        isFavorite.accept(favoritesRepo.isFavorite(movie))
    }

    func trailerURL() -> URL? {
        // simple YouTube search query
        let encoded = movie.Title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://www.youtube.com/results?search_query=\(encoded)+trailer")
    }
}
