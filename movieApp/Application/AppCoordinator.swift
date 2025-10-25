//
//  AppCoordinator.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Here we decide what the first flow / first screen is.
        let movieListCoordinator = MovieListCoordinator(navigationController: navigationController!)
        movieListCoordinator.start()
    }
}

