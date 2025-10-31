//
//  MovieDetailsViewModelTests.swift
//  movieApp
//
//  Created by Karwan on 27/10/2025.
//

import XCTest
import RxRelay
@testable import movieApp

final class MovieDetailsViewModelTests: XCTestCase {
    var repo: FavoritesRepository!
    var movie: Movie!

    override func setUp() {
        repo = FavoritesRepository()
        movie = Movie(title: "Doctor Strange", year: "2016", runtime: "115", poster: nil)
        UserDefaults.standard.removeObject(forKey: "FAVORITE_MOVIE_TITLES")
    }

    func test_toggleFavorite_updatesState() {
        let viewModel = MovieDetailsViewModel(movie: movie, favoritesRepo: repo)
        
        let expectation = expectation(description: "Favorite state updated")
        var isFavorite = false
        
        _ = viewModel.output.isFavorite
            .drive(onNext: { value in
                isFavorite = value
            })
        
        XCTAssertFalse(isFavorite)
        viewModel.input.toggleFavorite()
        
        // Give time for the driver to emit
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(isFavorite)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

    func test_trailerURL_containsMovieTitle() {
        let viewModel = MovieDetailsViewModel(movie: movie, favoritesRepo: repo)
        let url = viewModel.input.trailerButtonTapped()
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("Doctor%20Strange"))
    }
}
