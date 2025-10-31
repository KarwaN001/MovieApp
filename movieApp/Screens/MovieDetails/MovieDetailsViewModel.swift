//
//  MovieDetailsViewModel.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Input Protocol
protocol MovieDetailsViewModelInput {
    func toggleFavorite()
    func trailerButtonTapped() -> URL?
}

// MARK: - Output Protocol
protocol MovieDetailsViewModelOutput {
    var title: Driver<String> { get }
    var year: Driver<String> { get }
    var runtime: Driver<String> { get }
    var poster: Driver<String> { get }
    var isFavorite: Driver<Bool> { get }
}

// MARK: - ViewModel Type Protocol
protocol MovieDetailsViewModelType {
    var input: MovieDetailsViewModelInput { get }
    var output: MovieDetailsViewModelOutput { get }
}

// MARK: - ViewModel Implementation
final class MovieDetailsViewModel: MovieDetailsViewModelType {

    // MARK: - Public Interface
    let input: MovieDetailsViewModelInput
    let output: MovieDetailsViewModelOutput

    // MARK: - Private Properties
    private let isFavoriteRelay: BehaviorRelay<Bool>
    private let movie: Movie
    private let favoritesRepo: FavoritesRepositoryProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(movie: Movie, favoritesRepo: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.movie = movie
        self.favoritesRepo = favoritesRepo
        self.isFavoriteRelay = BehaviorRelay(value: favoritesRepo.isFavorite(movie))

        // Initialize input and output
        self.input = Input(
            toggleFavoriteAction: { [weak self] in
                self?.handleToggleFavorite()
            },
            trailerURLProvider: { [weak self] in
                self?.generateTrailerURL()
            }
        )

        self.output = Output(
            title: Driver.just(movie.title),
            year: Driver.just(movie.year),
            runtime: Driver.just(movie.runtime ?? ""),
            poster: Driver.just(movie.poster ?? ""),
            isFavorite: isFavoriteRelay.asDriver()
        )
    }

    // MARK: - Private Methods
    private func handleToggleFavorite() {
        favoritesRepo.toggleFavorite(movie)
        isFavoriteRelay.accept(favoritesRepo.isFavorite(movie))
    }

    private func generateTrailerURL() -> URL? {
        let encoded = movie.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://www.youtube.com/results?search_query=\(encoded)+trailer")
    }
}

// MARK: - Input Implementation
private extension MovieDetailsViewModel {
    struct Input: MovieDetailsViewModelInput {
        let toggleFavoriteAction: () -> Void
        let trailerURLProvider: () -> URL?

        func toggleFavorite() {
            toggleFavoriteAction()
        }

        func trailerButtonTapped() -> URL? {
            trailerURLProvider()
        }
    }
}

// MARK: - Output Implementation
private extension MovieDetailsViewModel {
    struct Output: MovieDetailsViewModelOutput {
        let title: Driver<String>
        let year: Driver<String>
        let runtime: Driver<String>
        let poster: Driver<String>
        let isFavorite: Driver<Bool>
    }
}
