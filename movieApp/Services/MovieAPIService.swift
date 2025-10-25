//
//  MovieAPIService.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import Foundation
import RxSwift

protocol MovieAPIServiceProtocol {
    func fetchMovies() -> Observable<[Movie]>
}

final class MovieAPIService: MovieAPIServiceProtocol {

    private let baseURL = "https://my-json-server.typicode.com/horizon-code-academy/fake-movies-api/movies"

    func fetchMovies() -> Observable<[Movie]> {
        return Observable.create { observer in
            guard let url = URL(string: self.baseURL) else {
                observer.onError(NSError(domain: "bad_url", code: -1))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let data = data else {
                    observer.onError(NSError(domain: "no_data", code: -2))
                    return
                }

                do {
                    let result = try JSONDecoder().decode([Movie].self, from: data)
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }

            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
