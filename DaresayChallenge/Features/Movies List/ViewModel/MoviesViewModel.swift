//
//  MoviesViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import UIKit
import SwiftUI

protocol ListViewModelable {
    var totalCount: Int { get set }
    var itemsCount: Int { get }
    var isFinished: Bool { get set }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool
    func prefetchData() async
}

class MoviesViewModel {
    
    // MARK: - Variables
    private var moviesService: MoviesServiceProtocol
    
    private var currentPage: UInt = 1
    private var allMovies: [MoviesModel] = []
    private var configCache: ConfigurationModel?
    
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
    
    var isFinished = false
    var totalCount: Int = 0
    var itemsCount: Int {
        return allMovies.count
    }
    
    var isLoading = false
    
    // MARK: - Init
    init(moviesService: MoviesServiceProtocol) {
        self.moviesService = moviesService
    }
    
    // MARK: - Public methods
    @MainActor public func populate() async -> [MoviesModel] {
        isLoading = true
        
        async let movies = getPopularMovies()
        async let configs = getConfigs()
        
        let _ = await (movies, configs)
        
        isLoading = false
        return allMovies
    }
    
    @MainActor public func getPopularMovies() async -> [MoviesModel] {
        let httpRequest = ServerRequest.Movies.getMovies(page: currentPage)
        
        do {
            let results = try await moviesService.getMovies(httpRequest: httpRequest)
            
            if let movies = results.results {
                if movies.isEmpty {
                    self.isFinished = true
                }
                
                self.allMovies.append(contentsOf: movies)
                
                self.currentPage += 1
            }
        } catch {
            print(error)
        }
        
        return allMovies
    }
    
    public func title(forItemAt indexPath: Int) -> String? {
        let movie = self.item(at: indexPath)
        return movie.title
    }
    
    public func description(forItemAt indexPath: Int) -> String? {
        let movie = self.item(at: indexPath)
        let description = movie.overview
        return description
    }
    
    public func didSelect(itemAt indexPath: Int) -> MoviesModel {
        let movie = self.item(at: indexPath)
        return movie
    }
    
    public func imageURL(forItemAt indexPath: Int) -> URL? {
        let movie = self.item(at: indexPath)
        let imageURL = movie.posterURL
        return imageURL
    }
    
    public func isFavorite(forItemAt indexPath: Int) -> Bool {
        let movie = self.item(at: indexPath)
        
        if movie.isFavorite {
            return true
        }
        
        return favoriteMovies.contains(where: { $0.id == movie.movieID ?? 0 })
    }
    
    // MARK: - Helpers
    @discardableResult
    private func getConfigs() async -> ConfigurationModel? {
        let httpRequest = ServerRequest.Configuration.getConfigs()
        
        do {
            let results = try await moviesService.getConfigs(httpRequest: httpRequest)
            self.configCache = results
            UserDefaultsData.configModel = results
        } catch {
            print(error)
        }
        
        return configCache
    }
    
    func item(at index: Int) -> MoviesModel {
        allMovies[index]
    }
}

// MARK: - ListViewModelable
extension MoviesViewModel: ListViewModelable {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == itemsCount - 1
    }
    
    func prefetchData() async {
        let _ = await getPopularMovies()
    }
}
