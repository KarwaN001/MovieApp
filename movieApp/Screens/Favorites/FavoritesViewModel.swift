//
//  FavoritesViewModel.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Input Protocol
protocol FavoritesViewModelInput {
    func viewWillAppear()
}

// MARK: - Output Protocol
protocol FavoritesViewModelOutput {
    var favoriteMovies: Driver<[Movie]> { get }
}

// MARK: - ViewModel Type Protocol
protocol FavoritesViewModelType {
    var input: FavoritesViewModelInput { get }
    var output: FavoritesViewModelOutput { get }
}

// MARK: - ViewModel Implementation
final class FavoritesViewModel: FavoritesViewModelType {

    // MARK: - Public Interface
    let input: FavoritesViewModelInput
    let output: FavoritesViewModelOutput

    // MARK: - Private Properties
    private let favoriteMoviesRelay = BehaviorRelay<[Movie]>(value: [])
    private let favoritesRepo: FavoritesRepositoryProtocol

    // MARK: - Init
    init(favoritesRepo: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.favoritesRepo = favoritesRepo
        
        // Create input instance without viewModel reference
        let inputInstance = Input()
        self.input = inputInstance
        
        // Initialize output
        self.output = Output(
            favoriteMovies: favoriteMoviesRelay.asDriver()
        )
        
        // Now set the viewModel reference after self is fully initialized
        inputInstance.viewModel = self

        // Load favorites on init
        loadFavorites()
    }

    // MARK: - Private Methods
    private func loadFavorites() {
        let movies = favoritesRepo.favorites()
        favoriteMoviesRelay.accept(movies)
        print("❤️ Loaded \(movies.count) favorite movies")
    }
}

// MARK: - Input Implementation
private extension FavoritesViewModel {
    final class Input: FavoritesViewModelInput {
        weak var viewModel: FavoritesViewModel?

        func viewWillAppear() {
            viewModel?.loadFavorites()
        }
    }
}

// MARK: - Output Implementation
private extension FavoritesViewModel {
    struct Output: FavoritesViewModelOutput {
        let favoriteMovies: Driver<[Movie]>
    }
}
