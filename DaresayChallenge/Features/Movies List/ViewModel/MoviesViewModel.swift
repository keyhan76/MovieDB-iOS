//
//  MoviesViewModel.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import UIKit

protocol ListViewModelable {
    associatedtype T: Hashable
    var isFinished: Bool { get set }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool
    func prefetchData() async -> [T]
}

final class MoviesViewModel {
    
    // MARK: - Variables
    private var moviesService: MoviesServiceProtocol
    
    private var currentPage: UInt = 1
    private var allMovies: [MoviesModel] = []
    private var configCache: ConfigurationModel?
    
    private var itemsCount: Int {
        return allMovies.count
    }
    
    public var isFinished = false
    public var isLoading = false
    
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
    
    public func didSelect(itemAt indexPath: Int) -> MoviesModel {
        let movie = self.item(at: indexPath)
        return movie
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
    
    private func item(at index: Int) -> MoviesModel {
        allMovies[index]
    }
}

// MARK: - ListViewModelable
extension MoviesViewModel: ListViewModelable {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == itemsCount - 1
    }
    
    func prefetchData() async -> [MoviesModel] {
        return await getPopularMovies()
    }
}
