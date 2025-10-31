//
//  MovieAPIClient.swift
//  movieApp
//
//  Created by Karwan on 31/10/2025.
//

import Foundation
import RxSwift


protocol MovieAPIClientProtocol {
    func fetchMovies() -> Observable<[Movie]>
}

final class MovieAPIClient: MovieAPIClientProtocol {
    
    private let baseURL: String
    private let session: URLSession
    
    /// Initialize with custom configuration
    /// - Parameters:
    ///   - baseURL: The base URL for the API
    ///   - session: The URLSession instance to use (defaults to .shared)
    init(
        baseURL: String = "https://my-json-server.typicode.com/horizon-code-academy/fake-movies-api/movies",
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func fetchMovies() -> Observable<[Movie]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "MovieAPIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Client deallocated"]))
                return Disposables.create()
            }
            
            guard let url = URL(string: self.baseURL) else {
                observer.onError(NSError(domain: "MovieAPIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return Disposables.create()
            }
            
            let task = self.session.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(NSError(domain: "MovieAPIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    observer.onError(NSError(domain: "MovieAPIClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error: \(httpResponse.statusCode)"]))
                    return
                }
                
                guard let data = data else {
                    observer.onError(NSError(domain: "MovieAPIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                    return
                }
                
                do {
                    let movies = try JSONDecoder().decode([Movie].self, from: data)
                    print(" API Client: Fetched \(movies.count) movies from server")
                    observer.onNext(movies)
                    observer.onCompleted()
                } catch {
                    print(" API Client: Failed to decode movies - \(error)")
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

