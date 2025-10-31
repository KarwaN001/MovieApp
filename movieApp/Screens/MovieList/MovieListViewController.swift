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

    private let movieListView = MovieListView()
    private weak var navigationDelegate: MovieListCoordinatorNavigationDelegate?
    private let viewModel: MovieListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: MovieListViewModel,
         navigationDelegate: MovieListCoordinatorNavigationDelegate?) {
        self.viewModel = viewModel
        self.navigationDelegate = navigationDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() {
        view = movieListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        bindViewModel()
        viewModel.fetchMovies()
    }

    private func bindViewModel() {
        // Bind ViewModel outputs to View
        movieListView.bind(
            movies: viewModel.movies,
            isLoading: viewModel.isLoading,
            disposeBag: disposeBag
        )
        
        // Bind View events to actions
        movieListView.movieSelected
            .subscribe(onNext: { [weak self] movie in
                print("🎬 Movie tapped in ViewController:", movie.title)
                self?.navigationDelegate?.didSelectMovie(movie)
            })
            .disposed(by: disposeBag)
        
        movieListView.themeToggleTapped
            .subscribe(onNext: {
                // Theme toggle handled by ThemeToggleButton itself
            })
            .disposed(by: disposeBag)
    }
}
