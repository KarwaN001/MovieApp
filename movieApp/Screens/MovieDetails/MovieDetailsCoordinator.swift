//
//  MovieDetailsCoordinator.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit

final class MovieDetailsCoordinator: Coordinator {
    var navigationController: UINavigationController?
    private let movie: Movie

    init(navigationController: UINavigationController?, movie: Movie) {
        self.navigationController = navigationController
        self.movie = movie
    }

    func start() {
        // Placeholder details view controller until a real one exists.
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        vc.title = movie.title

        // Simple label to show something on screen
        let label = UILabel()
        label.text = "Details for: \(movie.title)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: vc.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: vc.view.trailingAnchor, constant: -16)
        ])

        navigationController?.pushViewController(vc, animated: true)
    }
}
