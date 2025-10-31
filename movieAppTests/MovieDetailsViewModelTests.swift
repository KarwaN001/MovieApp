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
        XCTAssertFalse(viewModel.isFavorite.value)
        viewModel.toggleFavorite()
        XCTAssertTrue(viewModel.isFavorite.value)
    }

    func test_trailerURL_containsMovieTitle() {
        let viewModel = MovieDetailsViewModel(movie: movie, favoritesRepo: repo)
        let url = viewModel.trailerURL()
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("Doctor%20Strange"))
    }
}
