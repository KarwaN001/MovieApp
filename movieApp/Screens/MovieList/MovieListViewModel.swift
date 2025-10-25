//
//  MovieListViewModel.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieListViewModel {

    // MARK: - Outputs (for the View)
    let movies: Driver<[Movie]>
    let isLoading: Driver<Bool>
    let errorMessage: Driver<String?>

    // MARK: - Private Relays
    private let moviesRelay = BehaviorRelay<[Movie]>(value: [])
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = BehaviorRelay<String?>(value: nil)

    private let apiService: MovieAPIServiceProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(apiService: MovieAPIServiceProtocol = MovieAPIService()) {
        self.apiService = apiService

        // Public outputs
        self.movies = moviesRelay.asDriver()
        self.isLoading = loadingRelay.asDriver()
        self.errorMessage = errorRelay.asDriver()
    }

    // MARK: - Methods
    func fetchMovies() {
        loadingRelay.accept(true)
        errorRelay.accept(nil)

        apiService.fetchMovies()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] movies in
                    print(" Movies fetched: \(movies.count)")
                    self?.moviesRelay.accept(movies)
                    self?.loadingRelay.accept(false)
                },
                onError: { [weak self] error in
                    print(" Error fetching movies:", error.localizedDescription)
                    self?.errorRelay.accept(error.localizedDescription)
                    self?.loadingRelay.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
