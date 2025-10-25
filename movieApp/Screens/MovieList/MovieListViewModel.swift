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

    // MARK: - Inputs
    // (later example: user taps a row)

    // MARK: - Outputs
    let movies: Driver<[Movie]>
    let isLoading: Driver<Bool>
    let errorMessage: Driver<String?>

    // MARK: - Private
    private let apiService: MovieAPIServiceProtocol
    private let disposeBag = DisposeBag()

    // Relays/Subjects for internal state
    private let moviesRelay = BehaviorRelay<[Movie]>(value: [])
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = BehaviorRelay<String?>(value: nil)

    init(apiService: MovieAPIServiceProtocol = MovieAPIService()) {
        self.apiService = apiService

        self.movies = moviesRelay.asDriver()
        self.isLoading = loadingRelay.asDriver()
        self.errorMessage = errorRelay.asDriver()
    }

    func fetchMovies() {
        loadingRelay.accept(true)
        errorRelay.accept(nil)

        apiService.fetchMovies()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] result in
                    self?.moviesRelay.accept(result)
                    self?.loadingRelay.accept(false)
                },
                onError: { [weak self] err in
                    self?.errorRelay.accept(err.localizedDescription)
                    self?.loadingRelay.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
