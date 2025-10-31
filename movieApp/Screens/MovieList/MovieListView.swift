//
//  MovieListView.swift
//  movieApp
//
//  Created by Karwan on 31/10/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieListView: UIView {
    // MARK: - UI Components
    private var collectionView: UICollectionView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Movies"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let themeToggleButton = ThemeToggleButton()
    
    // MARK: - Observables (Outputs to ViewController)
    var movieSelected: Observable<Movie> {
        collectionView.rx.modelSelected(Movie.self).asObservable()
    }
    
    var themeToggleTapped: Observable<Void> {
        themeToggleButton.rx.tap.asObservable()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Setup collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        // Calculate item size for 2 columns
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3 // left + middle + right
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 2
        let itemHeight = itemWidth * 1.5 // Aspect ratio for movie posters
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MovieCardCell.self, forCellWithReuseIdentifier: "MovieCardCell")
        
        addSubview(titleLabel)
        addSubview(themeToggleButton)
        addSubview(collectionView)
        addSubview(activityIndicator)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        themeToggleButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: themeToggleButton.leadingAnchor, constant: -12),
            
            themeToggleButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            themeToggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            themeToggleButton.widthAnchor.constraint(equalToConstant: 40),
            themeToggleButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public Configuration Methods
    func bind(movies: Driver<[Movie]>, isLoading: Driver<Bool>, disposeBag: DisposeBag) {
        // Bind movies to collection view
        movies
            .drive(collectionView.rx.items(cellIdentifier: "MovieCardCell", cellType: MovieCardCell.self)) { _, movie, cell in
                cell.configure(with: movie)
            }
            .disposed(by: disposeBag)
        
        // Bind loading state to activity indicator
        isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

// MARK: - MovieCardCell
final class MovieCardCell: UICollectionViewCell {
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private var imageLoadTask: DispatchWorkItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(yearLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            yearLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            yearLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            yearLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        posterImageView.image = nil
        
        // Cancel previous image load task
        imageLoadTask?.cancel()
        
        // Load poster image
        if let poster = movie.poster, let url = URL(string: poster) {
            let task = DispatchWorkItem { [weak self] in
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.posterImageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.posterImageView.image = UIImage(systemName: "film")
                        self?.posterImageView.tintColor = .systemGray3
                    }
                }
            }
            imageLoadTask = task
            DispatchQueue.global().async(execute: task)
        } else {
            posterImageView.image = UIImage(systemName: "film")
            posterImageView.tintColor = .systemGray3
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        posterImageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
    }
}
