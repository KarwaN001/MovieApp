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
        let mockRepository = MockMovieRepository()
        let viewModel = MovieListViewModel(repository: mockRepository)
        let expectation = expectation(description: "Movies loaded")

        // When
        viewModel.output.movies
            .drive(onNext: { movies in
                if !movies.isEmpty {
                    XCTAssertEqual(movies.first?.title, "Mock Movie")
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        viewModel.input.viewDidLoad()
        wait(for: [expectation], timeout: 1)
    }
}

// MARK: - Mock Repository
final class MockMovieRepository: MovieRepositoryProtocol {
    func fetchMovies() -> Observable<[Movie]> {
        let movie = Movie(title: "Mock Movie", year: "2024", runtime: "120", poster: nil)
        return Observable.just([movie])
    }
}
