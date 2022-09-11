//
//  Movies.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import Foundation
import UIKit

extension ServerModels {
    enum Movies {
        struct Request {}
        
        typealias Response = MovieSchema
    }
}

struct MovieSchema: ServerModel {
    let page: UInt?
    let results: [MoviesModel]?
    let totalPages, totalResults: UInt?
}

// MARK: - MovieModel
// Using a reference type here
// since we are passing it around in the app
// and modifying it's values.
final class MoviesModel: ServerModel {
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]?
    var movieID: Int?
    var originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var isFavorite: Bool = false
    
    var posterURL: URL? {
        imageURL(posterPath, typeAndSize: .poster(.w342))
    }
    
    var backgroundImageURL: URL? {
        imageURL(posterPath, typeAndSize: .backDrop(.w780))
    }
    
    var isAddedToFavorites: Bool {
        if isFavorite {
            return true
        }
        
        return favoriteMovies.contains(where: { $0.id == movieID ?? 0 })
    }
    
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
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath
        case genreIDS = "genreIds"
        case movieID = "id"
        case originalLanguage
        case originalTitle
        case overview, popularity
        case posterPath
        case releaseDate
        case title, video
        case voteAverage
        case voteCount
    }
    
    // MARK: - Init
    init() { }
    
    // MARK: - Helpers
    private func imageURL(_ url: String?, typeAndSize: ImageTypes) -> URL? {
        guard let url = url else { return nil }
        let urlBuilder = ImageBaseUrlBuilder(forTypeAndSize: typeAndSize)
        let fullUrl = urlBuilder.createURL(filePath: url)
        return fullUrl
    }
}

// MARK: - Equatable
extension MoviesModel: Equatable {
    static func == (lhs: MoviesModel, rhs: MoviesModel) -> Bool {
        return lhs.movieID == rhs.movieID
    }
}

extension MoviesModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieID)
    }
}
