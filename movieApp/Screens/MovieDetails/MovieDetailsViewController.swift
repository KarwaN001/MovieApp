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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        return button
    }()
    
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let metadataStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        return button
    }()
    
    private let trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch Trailer", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        return button
    }()

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
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(infoContainerView)
        view.addSubview(backButton)
        
        infoContainerView.addSubview(titleLabel)
        infoContainerView.addSubview(metadataStackView)
        infoContainerView.addSubview(trailerButton)
        infoContainerView.addSubview(favoriteButton)
        
        metadataStackView.addArrangedSubview(createMetadataCard(label: yearLabel, icon: "calendar"))
        metadataStackView.addArrangedSubview(createMetadataCard(label: runtimeLabel, icon: "clock"))
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        metadataStackView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        trailerButton.translatesAutoresizingMaskIntoConstraints = false
        
        let posterHeight: CGFloat = 500
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            infoContainerView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -20),
            infoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            
            metadataStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            metadataStackView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            metadataStackView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            metadataStackView.heightAnchor.constraint(equalToConstant: 60),
            
            trailerButton.topAnchor.constraint(equalTo: metadataStackView.bottomAnchor, constant: 24),
            trailerButton.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            trailerButton.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            
            favoriteButton.topAnchor.constraint(equalTo: trailerButton.bottomAnchor, constant: 12),
            favoriteButton.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),
            favoriteButton.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -32)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func createMetadataCard(label: UILabel, icon: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 12
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = .secondaryLabel
        iconImageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stackView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return container
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
                let title = isFav ? "Remove from Favorites" : "Add to Favorites"
                self?.favoriteButton.setTitle(title, for: .normal)
                self?.favoriteButton.tintColor = isFav ? .systemRed : .label
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
