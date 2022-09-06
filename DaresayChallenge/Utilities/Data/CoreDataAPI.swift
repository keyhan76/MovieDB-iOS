//
//  CoreDataAPI.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-05.
//

import Foundation
import CoreData

final class CoreDataAPI {
    
    let managedContext: NSManagedObjectContext
    let coreDataStore: CoreDataStore
    
    // MARK: - Init

    init(managedContext: NSManagedObjectContext, coreDataStore: CoreDataStore) {
        self.managedContext = managedContext
        self.coreDataStore = coreDataStore
    }
    
    // MARK: - Core Data Operations
    
    public func createManagedObject<T: NSManagedObject>(entity: T.Type) -> NSManagedObject {
        let entityName = String(describing: entity)
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
            fatalError("Couldn't create \(entityName) managed object.")
        }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        return managedObject
    }
    
    public func save() throws {
        try managedContext.save()
    }
    
    public func delete<T: NSManagedObject>(entity: T) throws {
        managedContext.delete(entity)
        try managedContext.save()
    }
}

