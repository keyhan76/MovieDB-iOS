//
//  Movie.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import Foundation
import CoreData

extension ServerModels {
    enum Movies {
        struct Request {}
        
        typealias Response = MovieSchema
    }
}

struct MovieSchema: ServerModel {
    let page: UInt?
    let results: [Movie]?
    let totalPages, totalResults: UInt?
}

// MARK: - MovieModel
class Movie: NSManagedObject, ServerModel {
    
    var posterURL: URL? {
        imageURL(posterPath, typeAndSize: .poster(.w342))
    }
    
    var backgroundImageURL: URL? {
        imageURL(posterPath, typeAndSize: .backDrop(.w780))
    }
    
    // MARK: - Init
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.movieID = try container.decode(Int64.self, forKey: .movieID)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
    }
    
    // MARK: - Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(movieID, forKey: .movieID)
        try container.encode(title, forKey: .title)
        try container.encode(overview, forKey: .overview)
        try container.encode(posterPath, forKey: .posterPath)
    }
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case overview
        case posterPath
        case title
        case voteAverage
    }
    
    // MARK: - Helpers
    private func imageURL(_ url: String?, typeAndSize: ImageTypes) -> URL? {
        guard let url = url else { return nil }
        let urlBuilder = ImageBaseUrlBuilder(forTypeAndSize: typeAndSize)
        let fullUrl = urlBuilder.createURL(filePath: url)
        return fullUrl
    }
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}
