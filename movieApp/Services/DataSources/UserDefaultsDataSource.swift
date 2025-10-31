//
//  UserDefaultsDataSource.swift
//  movieApp
//
//  Created by Karwan on 31/10/2025.
//

import Foundation

protocol FavoritesDataSourceProtocol {
    func save(_ movies: [Movie])
    func load() -> [Movie]
    func clear()
}



final class UserDefaultsDataSource: FavoritesDataSourceProtocol {
    
    private let key: String
    private let userDefaults: UserDefaults
    
    /// Initialize with custom UserDefaults instance (useful for testing)
    /// - Parameters:
    ///   - key: The key to use for storing favorites
    ///   - userDefaults: The UserDefaults instance to use (defaults to .standard)
    init(key: String = "FAVORITE_MOVIES", userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }
    
    func save(_ movies: [Movie]) {
        guard let data = try? JSONEncoder().encode(movies) else {
            print(" Failed to encode movies for storage")
            return
        }
        userDefaults.set(data, forKey: key)
        print(" Saved \(movies.count) favorite movies to UserDefaults")
    }
    
    func load() -> [Movie] {
        guard let data = userDefaults.data(forKey: key) else {
            return []
        }
        
        guard let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
            print("⚠️ Failed to decode movies from storage")
            return []
        }
        
        return movies
    }
    
    func clear() {
        userDefaults.removeObject(forKey: key)
        print("🗑️ Cleared all favorite movies from UserDefaults")
    }
}

