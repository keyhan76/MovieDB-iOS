//
//  MovieTableViewCell.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessibilityIdentifier = AccessibilityIdentifiers.moviesTableViewCell.rawValue
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension MovieTableViewCell {
    func setupUI() {
        accessoryType = .disclosureIndicator
    }
}

// MARK: - Configuration
extension MovieTableViewCell: TableViewCell {
    func configureCell(with item: ListViewModelable, indexPath: Int) {
        guard let viewModel = item as? MoviesViewModel else { return }
        
        let config = MovieCellContentConfiguration(viewModel: viewModel, indexPath: indexPath)
        contentConfiguration = config
    }
}
