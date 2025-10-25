//
//  MovieListCoordinator.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit

final class MovieListCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = MovieListViewModel()
        let vc = MovieListViewController(
            viewModel: vm,
            navigationDelegate: self
        )
        navigationController.pushViewController(vc, animated: false)
    }
}

extension MovieListCoordinator: MovieListCoordinatorNavigationDelegate {
    func didSelectMovie(_ movie: Movie) {
        print(" Movie selected:", movie.Title)
        let detailsCoordinator = MovieDetailsCoordinator(
            navigationController: navigationController,
            movie: movie
        )
        detailsCoordinator.start()
    }
}
