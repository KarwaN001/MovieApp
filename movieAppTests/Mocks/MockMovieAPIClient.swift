//
//  MockMovieAPIClient.swift
//  movieAppTests
//
//  Created by Karwan on 31/10/2025.
//

import Foundation
import RxSwift
@testable import movieApp

/// Mock implementation of MovieAPIClient for testing
/// Allows complete control over API responses without making real network calls
final class MockMovieAPIClient: MovieAPIClientProtocol {
    // MARK: - Properties
    var moviesToReturn: [Movie] = []
    var errorToThrow: Error?
    var fetchMoviesCallCount = 0
    
    // MARK: - MovieAPIClientProtocol
    func fetchMovies() -> Observable<[Movie]> {
        fetchMoviesCallCount += 1
        
        if let error = errorToThrow {
            return Observable.error(error)
        }
        
        return Observable.just(moviesToReturn)
    }
    
    // MARK: - Helper Methods
    func reset() {
        moviesToReturn = []
        errorToThrow = nil
        fetchMoviesCallCount = 0
    }
}
