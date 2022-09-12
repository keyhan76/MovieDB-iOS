//
//  MovieCellContentView.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-10.
//

import UIKit

class MovieCellContentView: UIView, UIContentView {
    
    // MARK: - Variables
    var configuration: UIContentConfiguration {
        didSet {
            configure(with: configuration)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 16)
        label.accessibilityIdentifier = AccessibilityIdentifiers.movieTitleLabel.rawValue
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.accessibilityIdentifier = AccessibilityIdentifiers.movieDescriptionLabel.rawValue
        return label
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = AccessibilityIdentifiers.movieImageView.rawValue
        return imageView
    }()
    
    private lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = AccessibilityIdentifiers.movieFavoriteImageView.rawValue
        return imageView
    }()
    
    private lazy var placeHolderImage: UIImage = {
        UIImage(systemName: "film")!
    }()
    
    // MARK: - Init
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    public func configure(with configuration: UIContentConfiguration) {
        guard let configuration = configuration as? MovieCellContentConfiguration<MoviesModel> else {
            return
        }
        
        let model = configuration.model
        
        updateUI(title: model.title, description: model.overview, imageURL: model.posterURL, isFavorite: model.isAddedToFavorites)
    }
    
    public func updateUI(title: String?, description: String?, imageURL: URL?, isFavorite: Bool) {
        titleLabel.text = title
        descriptionLabel.text = description
        
        movieImageView.load(url: imageURL, placeholder: placeHolderImage)
        
        if isFavorite{
            favoriteImageView.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteImageView.image = UIImage(systemName: "heart")
        }
    }
}

// MARK: - Helpers
extension MovieCellContentView {
    func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(movieImageView)
        addSubview(favoriteImageView)
        
        favoriteImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        favoriteImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        favoriteImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        favoriteImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        stackView.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 8).isActive = true
        stackView.rightAnchor.constraint(equalTo: favoriteImageView.leftAnchor, constant: -12).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        movieImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        movieImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
}
