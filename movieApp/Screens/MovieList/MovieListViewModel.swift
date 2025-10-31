//
//  MovieListViewModel.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Input Protocol
protocol MovieListViewModelInput {
    func viewDidLoad()
}

// MARK: - Output Protocol
protocol MovieListViewModelOutput {
    var movies: Driver<[Movie]> { get }
    var isLoading: Driver<Bool> { get }
    var errorMessage: Driver<String?> { get }
}

// MARK: - ViewModel Type Protocol
protocol MovieListViewModelType {
    var input: MovieListViewModelInput { get }
    var output: MovieListViewModelOutput { get }
}

// MARK: - ViewModel Implementation
final class MovieListViewModel: MovieListViewModelType {

    // MARK: - Public Interface
    let input: MovieListViewModelInput
    let output: MovieListViewModelOutput

    // MARK: - Private Properties
    private let moviesRelay = BehaviorRelay<[Movie]>(value: [])
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = BehaviorRelay<String?>(value: nil)

    private let apiService: MovieAPIServiceProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(apiService: MovieAPIServiceProtocol = MovieAPIService()) {
        self.apiService = apiService

        // Initialize input and output
        self.input = Input(
            fetchMoviesAction: { [weak self] in
                self?.fetchMovies()
            }
        )

        self.output = Output(
            movies: moviesRelay.asDriver(),
            isLoading: loadingRelay.asDriver(),
            errorMessage: errorRelay.asDriver()
        )
    }

    // MARK: - Private Methods
    private func fetchMovies() {
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

// MARK: - Input Implementation
private extension MovieListViewModel {
    struct Input: MovieListViewModelInput {
        let fetchMoviesAction: () -> Void

        func viewDidLoad() {
            fetchMoviesAction()
        }
    }
}

// MARK: - Output Implementation
private extension MovieListViewModel {
    struct Output: MovieListViewModelOutput {
        let movies: Driver<[Movie]>
        let isLoading: Driver<Bool>
        let errorMessage: Driver<String?>
    }
}
