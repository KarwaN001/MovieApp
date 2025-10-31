//
//  MovieDetailsViewModelTests.swift
//  movieAppTests
//
//  Created by Karwan on 27/10/2025.
//

import XCTest
import RxSwift
import RxCocoa
@testable import movieApp

final class MovieDetailsViewModelTests: XCTestCase {
    var mockRepo: MockFavoritesRepository!
    var movie: Movie!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepo = MockFavoritesRepository()
        movie = Movie(title: "Doctor Strange", year: "2016", runtime: "115", poster: nil)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        mockRepo = nil
        movie = nil
        disposeBag = nil
        super.tearDown()
    }

    func test_toggleFavorite_updatesState() {
        // Given
        let viewModel = MovieDetailsViewModel(movie: movie, favoritesRepo: mockRepo)
        var capturedStates: [Bool] = []
        
        viewModel.output.isFavorite
            .drive(onNext: { isFavorite in
                capturedStates.append(isFavorite)
            })
            .disposed(by: disposeBag)
        
        // When
        viewModel.input.toggleFavorite()
        
        // Then
        XCTAssertEqual(capturedStates.count, 2) // Initial + after toggle
        XCTAssertFalse(capturedStates[0]) // Initially not favorite
        XCTAssertTrue(capturedStates[1]) // After toggle, is favorite
        XCTAssertEqual(mockRepo.toggleFavoriteCallCount, 1)
    }
    
    func test_toggleFavorite_twice_returnsToOriginalState() {
        // Given
        let viewModel = MovieDetailsViewModel(movie: movie, favoritesRepo: mockRepo)
        var capturedStates: [Bool] = []
        
        viewModel.output.isFavorite
            .drive(onNext: { isFavorite in
                capturedStates.append(isFavorite)
            })
            .disposed(by: disposeBag)
        
        // When
        viewModel.input.toggleFavorite()
        viewModel.input.toggleFavorite()
        
        // Then
        XCTAssertEqual(capturedStates.count, 3)
        XCTAssertFalse(capturedStates[0]) // Initial
        XCTAssertTrue(capturedStates[1])  // After first toggle
        XCTAssertFalse(capturedStates[2]) // After second toggle
        XCTAssertEqual(mockRepo.toggleFavoriteCallCount, 2)
    }

    func test_trailerURL_containsMovieTitle() {
        // Given
        let viewModel = MovieDetailsViewModel(movie: movie, favoritesRepo: mockRepo)
        
        // When
        let url = viewModel.input.trailerButtonTapped()
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("Doctor%20Strange"))
        XCTAssertTrue(url!.absoluteString.contains("youtube.com"))
    }
    
    func test_output_providesCorrectMovieData() {
        // Given
        let viewModel = MovieDetailsViewModel(movie: movie, favoritesRepo: mockRepo)
        var capturedTitle: String?
        var capturedYear: String?
        var capturedRuntime: String?
        
        // When
        viewModel.output.title.drive(onNext: { capturedTitle = $0 }).disposed(by: disposeBag)
        viewModel.output.year.drive(onNext: { capturedYear = $0 }).disposed(by: disposeBag)
        viewModel.output.runtime.drive(onNext: { capturedRuntime = $0 }).disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(capturedTitle, "Doctor Strange")
        XCTAssertEqual(capturedYear, "2016")
        XCTAssertEqual(capturedRuntime, "115")
    }
}
