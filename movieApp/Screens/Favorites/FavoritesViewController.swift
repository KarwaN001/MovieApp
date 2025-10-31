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
    
    private let favoritesView = FavoritesView()
    private let viewModel: FavoritesViewModel
    private let disposeBag = DisposeBag()
    private weak var navigationDelegate: FavoritesCoordinatorNavigationDelegate?

    init(viewModel: FavoritesViewModel, navigationDelegate: FavoritesCoordinatorNavigationDelegate?) {
        self.viewModel = viewModel
        self.navigationDelegate = navigationDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() {
        view = favoritesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        bindViewModel()
    }

    private func bindViewModel() {
        // Bind ViewModel outputs to View
        favoritesView.bind(
            movies: viewModel.output.favoriteMovies,
            disposeBag: disposeBag
        )
        
        // Bind View events to actions
        favoritesView.movieSelected
            .subscribe(onNext: { [weak self] movie in
                print("❤️ Favorite movie tapped:", movie.title)
                self?.navigationDelegate?.didSelectFavoriteMovie(movie)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear()
    }
}
