//
//  CoreDataManager.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-12.
//

import UIKit

final class CoreDataManager {
    
    // MARK: - Variables
    public lazy var favoriteMovies: [Movie] = {
        var favMovies: [Movie] = []
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return []
        }
        
        guard let coreDataAPI = sceneDelegate.coreDataAPI else { return [] }
        
        do {
            favMovies = try coreDataAPI.fetchAllObjects(entity: Movie.self)
        } catch let error {
            print(error)
        }
        
        return favMovies
    }()
}
