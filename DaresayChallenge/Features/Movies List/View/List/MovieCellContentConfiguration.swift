//
//  MovieCellContentConfiguration.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-10.
//

import UIKit

struct MovieCellContentConfiguration<T: Hashable>: UIContentConfiguration {
    
    let model: T
    
    func makeContentView() -> UIView & UIContentView {
        MovieCellContentView(self)
    }
    
    func updated(for state: UIConfigurationState) -> MovieCellContentConfiguration {
        return self
    }
}
