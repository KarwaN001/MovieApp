//
//  FavoritesViewController.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit
import RxSwift
import RxCocoa

protocol FavoritesCoordinatorNavigationDelegate: AnyObject {
    func didSelectFavoriteMovie(_ movie: Movie)
}

final class FavoritesViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: FavoritesViewModel
    private let disposeBag = DisposeBag()
    private weak var navigationDelegate: FavoritesCoordinatorNavigationDelegate?

    init(viewModel: FavoritesViewModel, navigationDelegate: FavoritesCoordinatorNavigationDelegate?) {
        self.viewModel = viewModel
        self.navigationDelegate = navigationDelegate
        super.init(nibName: nil, bundle: nil)
        self.title = "Favorites"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.favoriteMovies
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { _, movie, cell in
                cell.textLabel?.text = movie.title
                cell.accessoryType = .disclosureIndicator
            }
            .disposed(by: disposeBag)

        // Handle row selection
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                print("❤️ Favorite movie tapped:", movie.title)
                self?.navigationDelegate?.didSelectFavoriteMovie(movie)
                // Deselect the row for better UX
                if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)

        tableView.rx.modelDeleted(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                self?.viewModel.removeFavorite(movie)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
}
