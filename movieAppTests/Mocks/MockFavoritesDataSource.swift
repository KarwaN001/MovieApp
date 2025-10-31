//
//  MockFavoritesDataSource.swift
//  movieAppTests
//
//  Created by Karwan on 31/10/2025.
//

import Foundation
@testable import movieApp

/// Mock implementation of FavoritesDataSource for testing
/// Uses in-memory storage instead of UserDefaults for fast, isolated tests
final class MockFavoritesDataSource: FavoritesDataSourceProtocol {
    // MARK: - Properties
    private var storage: [Movie] = []
    var saveCallCount = 0
    var loadCallCount = 0
    var clearCallCount = 0
    
    // MARK: - FavoritesDataSourceProtocol
    func save(_ movies: [Movie]) {
        saveCallCount += 1
        storage = movies
    }
    
    func load() -> [Movie] {
        loadCallCount += 1
        return storage
    }
    
    func clear() {
        clearCallCount += 1
        storage = []
    }
    
    // MARK: - Helper Methods
    func reset() {
        storage = []
        saveCallCount = 0
        loadCallCount = 0
        clearCallCount = 0
    }
}
