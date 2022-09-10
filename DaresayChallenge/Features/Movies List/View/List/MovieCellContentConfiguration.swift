//
//  MovieCellContentConfiguration.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-10.
//

import UIKit

struct MovieCellContentConfiguration<T: ListViewModelable>: UIContentConfiguration {
    
    let viewModel: T
    let indexPath: Int
    
    func makeContentView() -> UIView & UIContentView {
        MovieCellContentView(self)
    }
    
    func updated(for state: UIConfigurationState) -> MovieCellContentConfiguration {
        return self
    }
}
