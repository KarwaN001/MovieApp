//
//  MovieListViewModelTests.swift
//  movieApp
//
//  Created by Karwan on 27/10/2025.
//

import XCTest
import RxSwift
import RxCocoa
@testable import movieApp

final class MovieListViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    func test_fetchMovies_success() {
        // Given
        let mockService = MockMovieAPIService()
        let viewModel = MovieListViewModel(apiService: mockService)
        let expectation = expectation(description: "Movies loaded")

        // When
        viewModel.movies
            .drive(onNext: { movies in
                if !movies.isEmpty {
                    XCTAssertEqual(movies.first?.Title, "Mock Movie")
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        viewModel.fetchMovies()
        wait(for: [expectation], timeout: 1)
    }
}

// MARK: - Mock Service
final class MockMovieAPIService: MovieAPIServiceProtocol {
    func fetchMovies() -> Observable<[Movie]> {
        let movie = Movie(Title: "Mock Movie", Year: "2024", Runtime: "120", Poster: nil)
        return Observable.just([movie])
    }
}
