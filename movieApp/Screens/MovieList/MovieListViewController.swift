//
//  MovieListViewController.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit
import RxSwift
import RxCocoa

protocol MovieListCoordinatorNavigationDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
}

final class MovieListViewController: UIViewController {

    private weak var navigationDelegate: MovieListCoordinatorNavigationDelegate?
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let viewModel: MovieListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: MovieListViewModel,
         navigationDelegate: MovieListCoordinatorNavigationDelegate?) {
        self.viewModel = viewModel
        self.navigationDelegate = navigationDelegate
        super.init(nibName: nil, bundle: nil)
        self.title = "Movies"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindViewModel()
        viewModel.fetchMovies()
    }

    private func setupLayout() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        // movies -> tableView
        viewModel.movies
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { _, movie, cell in
                cell.textLabel?.text = movie.title

                // Load poster image
                if let poster = movie.poster, let url = URL(string: poster) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url),
                           let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.imageView?.image = image
                                cell.setNeedsLayout()
                            }
                        }
                    }
                } else {
                    cell.imageView?.image = UIImage(systemName: "film")
                }

                cell.accessoryType = .disclosureIndicator
            }
            .disposed(by: disposeBag)

        // loading -> spinner
        viewModel.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        // tap row -
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                self?.navigationDelegate?.didSelectMovie(movie)
            })
            .disposed(by: disposeBag)

    }
}
