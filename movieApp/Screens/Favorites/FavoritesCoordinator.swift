//
//  FavoritesCoordinator.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = FavoritesViewModel()
        let viewController = FavoritesViewController(viewModel: viewModel, navigationDelegate: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension FavoritesCoordinator: FavoritesCoordinatorNavigationDelegate {
    func didSelectFavoriteMovie(_ movie: Movie) {
        print("❤️ Favorite movie selected:", movie.title)
        let detailsCoordinator = MovieDetailsCoordinator(
            navigationController: navigationController,
            movie: movie
        )
        detailsCoordinator.start()
    }
}
