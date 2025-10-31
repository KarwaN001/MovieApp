//
//  FavoritesRepositoryTests.swift
//  movieAppTests
//
//  Created by Karwan on 27/10/2025.
//

import XCTest
@testable import movieApp

final class FavoritesRepositoryTests: XCTestCase {

    var repo: FavoritesRepository!
    var mockDataSource: MockFavoritesDataSource!
    var sampleMovie: Movie!

    override func setUp() {
        super.setUp()
        // Use mock data source for fast, isolated tests
        mockDataSource = MockFavoritesDataSource()
        repo = FavoritesRepository(dataSource: mockDataSource)
        sampleMovie = Movie(
            title: "Test Movie",
            year: "2025",
            runtime: "120 min",
            poster: nil
        )
    }

    override func tearDown() {
        repo = nil
        mockDataSource = nil
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
    
    func test_toggleFavorite_callsDataSourceSave() {
        // Given
        let initialCallCount = mockDataSource.saveCallCount
        
        // When
        repo.toggleFavorite(sampleMovie)
        
        // Then
        XCTAssertEqual(mockDataSource.saveCallCount, initialCallCount + 1)
    }
    
    func test_isFavorite_callsDataSourceLoad() {
        // Given
        let initialCallCount = mockDataSource.loadCallCount
        
        // When
        _ = repo.isFavorite(sampleMovie)
        
        // Then
        XCTAssertEqual(mockDataSource.loadCallCount, initialCallCount + 1)
    }
    
    func test_toggleFavorite_multipleMovies() {
        // Given
        let movie1 = Movie(title: "Movie 1", year: "2024", runtime: "120", poster: nil)
        let movie2 = Movie(title: "Movie 2", year: "2023", runtime: "110", poster: nil)
        
        // When
        repo.toggleFavorite(movie1)
        repo.toggleFavorite(movie2)
        
        // Then
        XCTAssertTrue(repo.isFavorite(movie1))
        XCTAssertTrue(repo.isFavorite(movie2))
        XCTAssertEqual(repo.favorites().count, 2)
    }
}
