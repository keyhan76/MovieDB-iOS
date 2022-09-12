//
//  FavoriteMovieTableViewCell.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-11.
//

import UIKit

final class FavoriteMovieTableViewCell: UITableViewCell {

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
extension FavoriteMovieTableViewCell: DiffableTableViewCell {
    func configureCellWith(_ item: Movie) {
        let config = FavoriteMovieCellContentConfiguration(model: item)
        contentConfiguration = config
    }
}

// MARK: - FavoriteMovie Cell ContentView
final class FavoriteMovieCellContentView: MovieCellContentView {
    override func configure(with configuration: UIContentConfiguration) {
        guard let configuration = configuration as? FavoriteMovieCellContentConfiguration<Movie> else {
            return
        }
        
        titleLabel.text = configuration.model.title
        descriptionLabel.text = configuration.model.movieDescription
        
        let imageURL = configuration.model.imageURL
        movieImageView.load(url: imageURL, placeholder: placeHolderImage)
        
        if configuration.model.isFavorite {
            favoriteImageView.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteImageView.image = UIImage(systemName: "heart")
        }
    }
}

// MARK: - FavoriteMovie Cell Content Configuration
struct FavoriteMovieCellContentConfiguration<T: Hashable>: UIContentConfiguration {
    
    let model: T
    
    func makeContentView() -> UIView & UIContentView {
        FavoriteMovieCellContentView(self)
    }
    
    func updated(for state: UIConfigurationState) -> FavoriteMovieCellContentConfiguration {
        return self
    }
}

