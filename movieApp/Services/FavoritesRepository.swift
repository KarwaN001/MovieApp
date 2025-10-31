//
//  FavoritesRepository.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func toggleFavorite(_ movie: Movie)
    func isFavorite(_ movie: Movie) -> Bool
    func favorites() -> [Movie]
}

/// Repository for managing favorite movies
/// Coordinates data storage through data source abstraction
final class FavoritesRepository: FavoritesRepositoryProtocol {
    
    private let dataSource: FavoritesDataSourceProtocol
    
    /// Initialize with custom data source
    /// - Parameter dataSource: The data source to use for persistence
    init(dataSource: FavoritesDataSourceProtocol = UserDefaultsDataSource()) {
        self.dataSource = dataSource
    }
    
    func toggleFavorite(_ movie: Movie) {
        var list = dataSource.load()
        
        if let index = list.firstIndex(where: { $0.title == movie.title }) {
            list.remove(at: index)
            print(" Removed '\(movie.title)' from favorites")
        } else {
            list.append(movie)
            print(" Added '\(movie.title)' to favorites")
        }
        
        dataSource.save(list)
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        let list = dataSource.load()
        return list.contains(where: { $0.title == movie.title })
    }
    
    func favorites() -> [Movie] {
        return dataSource.load()
    }
}
