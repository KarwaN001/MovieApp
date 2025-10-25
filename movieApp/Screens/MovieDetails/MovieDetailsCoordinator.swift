//
//  MovieDetailsCoordinator.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit

final class MovieDetailsCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let movie: Movie

    init(navigationController: UINavigationController, movie: Movie) {
        self.navigationController = navigationController
        self.movie = movie
    }

    func start() {
        let viewModel = MovieDetailsViewModel(movie: movie)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
