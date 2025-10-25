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
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let trailerButton = UIButton(type: .system)

    private let viewModel: MovieDetailsViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        print("✅ MovieDetailsViewController loaded for:", viewModel.title)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Movie Details"

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true

        titleLabel.font = .boldSystemFont(ofSize: 22)
        yearLabel.textColor = .secondaryLabel
        runtimeLabel.textColor = .secondaryLabel

        favoriteButton.setTitle("❤️ Add to Favorites", for: .normal)
        trailerButton.setTitle("▶️ Watch Trailer", for: .normal)

        let stack = UIStackView(arrangedSubviews: [posterImageView, titleLabel, yearLabel, runtimeLabel, favoriteButton, trailerButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 280),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func bindViewModel() {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.year.drive(yearLabel.rx.text).disposed(by: disposeBag)
        viewModel.runtime.drive(runtimeLabel.rx.text).disposed(by: disposeBag)

        viewModel.poster.drive(onNext: { [weak self] urlString in
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.posterImageView.image = image }
                }
            }
        }).disposed(by: disposeBag)

        viewModel.isFavorite
            .asDriver()
            .drive(onNext: { [weak self] isFav in
                self?.favoriteButton.setTitle(isFav ? "💔 Remove from Favorites" : "❤️ Add to Favorites", for: .normal)
            })
            .disposed(by: disposeBag)

        favoriteButton.rx.tap
            .bind { [weak self] in self?.viewModel.toggleFavorite() }
            .disposed(by: disposeBag)

        trailerButton.rx.tap
            .bind { [weak self] in
                guard let url = self?.viewModel.trailerURL() else { return }
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
