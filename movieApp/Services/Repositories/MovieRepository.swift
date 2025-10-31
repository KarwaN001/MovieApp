//
//  MovieRepository.swift
//  movieApp
//
//  Created by Karwan on 31/10/2025.
//

import Foundation
import RxSwift

protocol MovieRepositoryProtocol {
    func fetchMovies() -> Observable<[Movie]>
}

final class MovieRepository: MovieRepositoryProtocol {
    private let apiClient: MovieAPIClientProtocol
    init(apiClient: MovieAPIClientProtocol = MovieAPIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchMovies() -> Observable<[Movie]> {
        return apiClient.fetchMovies()
            .do(onNext: { movies in
                print(" Repository: Provided \(movies.count) movies to ViewModel")
            })
    }
}
