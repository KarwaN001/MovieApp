//
//  MovieDetailsViewController.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

final class MovieDetailsViewController: UIViewController {
    
    private let detailsView = MovieDetailsView()
    private let viewModel: MovieDetailsViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() {
        view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        bindViewModel()
        print("✅ MovieDetailsViewController loaded for:", viewModel.title)
    }

    private func bindViewModel() {
        // Bind ViewModel outputs to View
        Driver.combineLatest(
            viewModel.title,
            viewModel.year,
            viewModel.runtime,
            viewModel.poster
        )
        .drive(onNext: { [weak self] title, year, runtime, poster in
            self?.detailsView.configure(title: title, year: year, runtime: runtime, posterURL: poster)
        })
        .disposed(by: disposeBag)
        
        viewModel.isFavorite
            .asDriver()
            .drive(onNext: { [weak self] isFavorite in
                self?.detailsView.updateFavoriteButton(isFavorite: isFavorite)
            })
            .disposed(by: disposeBag)
        
        // Bind View events to ViewModel/Actions
        detailsView.backButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        detailsView.favoriteButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.viewModel.toggleFavorite()
            })
            .disposed(by: disposeBag)
        
        detailsView.trailerButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let url = self?.viewModel.trailerURL() else { return }
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
