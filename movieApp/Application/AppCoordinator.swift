//
//  AppCoordinator.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private var tabBarController: UITabBarController?
    
    private var movieListCoordinator: MovieListCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
            let tabBarController = UITabBarController()

            // --- Movies Tab ---
            let movieNav = UINavigationController()
            let movieListCoordinator = MovieListCoordinator(navigationController: movieNav)
            movieListCoordinator.start()
            self.movieListCoordinator = movieListCoordinator // Keep strong reference
            movieNav.tabBarItem = UITabBarItem(title: "Movies",
                                               image: UIImage(systemName: "film"),
                                               selectedImage: UIImage(systemName: "film.fill"))

            // --- Favorites Tab ---
            let favoriteNav = UINavigationController()
            let favoritesCoordinator = FavoritesCoordinator(navigationController: favoriteNav)
            favoritesCoordinator.start()
            self.favoritesCoordinator = favoritesCoordinator // Keep strong reference
            favoriteNav.tabBarItem = UITabBarItem(title: "Favorites",
                                                  image: UIImage(systemName: "heart"),
                                                  selectedImage: UIImage(systemName: "heart.fill"))

            // --- Setup tab bar ---
            tabBarController.viewControllers = [movieNav, favoriteNav]
            tabBarController.tabBar.tintColor = .systemRed

        navigationController.setViewControllers([tabBarController], animated: false)
            self.tabBarController = tabBarController
        }
}

