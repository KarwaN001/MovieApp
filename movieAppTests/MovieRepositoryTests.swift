//
//  MovieRepositoryTests.swift
//  movieAppTests
//
//  Created by Karwan on 31/10/2025.
//

import XCTest
import RxSwift
import RxBlocking
@testable import movieApp

final class MovieRepositoryTests: XCTestCase {
    var repository: MovieRepository!
    var mockAPIClient: MockMovieAPIClient!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockMovieAPIClient()
        repository = MovieRepository(apiClient: mockAPIClient)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        repository = nil
        mockAPIClient = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    
    func test_fetchMovies_success_returnsMovies() throws {
        // Given
        let expectedMovies = [
            Movie(title: "Movie 1", year: "2024", runtime: "120", poster: nil),
            Movie(title: "Movie 2", year: "2023", runtime: "110", poster: nil)
        ]
        mockAPIClient.moviesToReturn = expectedMovies
        
        // When
        let movies = try repository.fetchMovies()
            .toBlocking()
            .first()
        
        // Then
        XCTAssertEqual(movies?.count, 2)
        XCTAssertEqual(movies?.first?.title, "Movie 1")
        XCTAssertEqual(mockAPIClient.fetchMoviesCallCount, 1)
    }
    
    func test_fetchMovies_success_emptyArray() throws {
        // Given
        mockAPIClient.moviesToReturn = []
        
        // When
        let movies = try repository.fetchMovies()
            .toBlocking()
            .first()
        
        // Then
        XCTAssertEqual(movies?.count, 0)
        XCTAssertTrue(movies?.isEmpty ?? false)
    }
    
    // MARK: - Error Tests
    
    func test_fetchMovies_networkError_throwsError() {
        // Given
        let expectedError = NSError(domain: "NetworkError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        mockAPIClient.errorToThrow = expectedError
        
        // When/Then
        XCTAssertThrowsError(try repository.fetchMovies().toBlocking().first()) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "NetworkError")
            XCTAssertEqual(nsError.code, 500)
        }
    }
    
    func test_fetchMovies_timeoutError_throwsError() {
        // Given
        let timeoutError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
        mockAPIClient.errorToThrow = timeoutError
        
        // When/Then
        XCTAssertThrowsError(try repository.fetchMovies().toBlocking().first()) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, NSURLErrorTimedOut)
        }
    }
    
    // MARK: - Multiple Calls Tests
    
    func test_fetchMovies_multipleCalls_returnsConsistentResults() throws {
        // Given
        let expectedMovies = [
            Movie(title: "Test Movie", year: "2024", runtime: "120", poster: nil)
        ]
        mockAPIClient.moviesToReturn = expectedMovies
        
        // When
        let firstCall = try repository.fetchMovies().toBlocking().first()
        let secondCall = try repository.fetchMovies().toBlocking().first()
        
        // Then
        XCTAssertEqual(firstCall?.count, secondCall?.count)
        XCTAssertEqual(mockAPIClient.fetchMoviesCallCount, 2)
    }
}
