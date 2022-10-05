//
//  Movie+CoreDataClass.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-15.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

public class Movie: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case overview
        case posterPath
        case title
        case voteAverage
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.movieID = try container.decode(Int64.self, forKey: .movieID)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(movieID, forKey: .movieID)
        try container.encode(overview, forKey: .overview)
        try container.encode(title, forKey: .title)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(voteAverage, forKey: .voteAverage)
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
