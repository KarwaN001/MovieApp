//
//  Untitled.swift
//  movieApp
//
//  Created by Karwan on 27/10/2025.
//

import XCTest
@testable import movieApp

final class FavoritesRepositoryTests: XCTestCase {

    var repo: FavoritesRepository!
    var sampleMovie: Movie!

    override func setUp() {
        super.setUp()
        // Use a separate key for testing to avoid interfering with real app data
        let testDataSource = UserDefaultsDataSource(key: "TEST_FAVORITE_MOVIES", userDefaults: .standard)
        repo = FavoritesRepository(dataSource: testDataSource)
        sampleMovie = Movie(
            title: "Test Movie",
            year: "2025",
            runtime: "120 min",
            poster: nil
        )

        // Clear previous stored favorites
        UserDefaults.standard.removeObject(forKey: "TEST_FAVORITE_MOVIES")
    }

    override func tearDown() {
        repo = nil
        sampleMovie = nil
        super.tearDown()
    }

    func test_toggleFavorite_addsAndRemovesMovie() {
        // Add
        repo.toggleFavorite(sampleMovie)
        XCTAssertTrue(repo.isFavorite(sampleMovie), "Movie should be added to favorites")

        // Remove
        repo.toggleFavorite(sampleMovie)
        XCTAssertFalse(repo.isFavorite(sampleMovie), "Movie should be removed from favorites")
    }

    func test_isFavorite_returnsTrueAfterAdding() {
        repo.toggleFavorite(sampleMovie)
        XCTAssertTrue(repo.isFavorite(sampleMovie), "isFavorite should return true for added movie")
    }

    func test_isFavorite_returnsFalseWhenEmpty() {
        XCTAssertFalse(repo.isFavorite(sampleMovie), "isFavorite should return false if not added")
    }

    func test_favorites_returnsStoredMovies() {
        repo.toggleFavorite(sampleMovie)
        let favorites = repo.favorites()
        XCTAssertEqual(favorites.count, 1, "Should return 1 favorite movie")
        XCTAssertEqual(favorites.first?.title, "Test Movie")
    }
}
