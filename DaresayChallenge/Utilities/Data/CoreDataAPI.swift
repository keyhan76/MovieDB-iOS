//
//  CoreDataAPI.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-05.
//

import Foundation
import CoreData

protocol CoreDataAPIProtocol {
    var managedContext: NSManagedObjectContext { get }
    var coreDataStore: CoreDataStore { get }
    
    func save() throws
    func delete<T: NSManagedObject>(entity: T) throws
    func fetchAllObjects<T: NSManagedObject>(entity: T.Type) throws -> [T]
    func createManagedObject<T: NSManagedObject>(entity: T.Type) -> NSManagedObject
    func fetchObject<T: NSManagedObject>(movieID: Int, entity: T.Type) throws -> [T]
    func fetch<T: NSManagedObject>(entity: T.Type) throws -> NSFetchedResultsController<T>
}

final class CoreDataAPI {
    
    // MARK: - Variables
    let managedContext: NSManagedObjectContext
    let coreDataStore: CoreDataStore
    
    // MARK: - Init

    init(managedContext: NSManagedObjectContext, coreDataStore: CoreDataStore) {
        self.managedContext = managedContext
        self.coreDataStore = coreDataStore
    }
    
    // MARK: - Core Data Operations
    
    private func generate<T: NSManagedObject>(entity: T.Type) -> NSEntityDescription {
        let entityName = String(describing: entity)
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
            fatalError("Couldn't create \(entityName) managed object.")
        }
        
        return entity
    }
}

// MARK: - CoreDataAPI Protocol
extension CoreDataAPI: CoreDataAPIProtocol {
    func createManagedObject<T: NSManagedObject>(entity: T.Type) -> NSManagedObject {
        
        let entity = generate(entity: entity)
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        return managedObject
    }
    
    func save() throws {
        coreDataStore.saveContext(managedContext)
    }
    
    func delete<T: NSManagedObject>(entity: T) throws {
        managedContext.delete(entity)
        coreDataStore.saveContext(managedContext)
    }
    
    func fetchAllObjects<T: NSManagedObject>(entity: T.Type) throws -> [T] {
        let fetchRequest = T.fetchRequest()
        
        let objects = try managedContext.fetch(fetchRequest) as! [T]
        return objects
    }
    
    func fetchObject<T: NSManagedObject>(movieID: Int, entity: T.Type) throws -> [T] {
        let fetchRequest = T.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id == %i", movieID)
        
        let objects = try managedContext.fetch(fetchRequest) as! [T]
        return objects
    }
    
    func fetch<T: NSManagedObject>(entity: T.Type) throws -> NSFetchedResultsController<T> {
        let entityName = String(describing: entity)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.fetchBatchSize = 20
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController<T>(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
         
        try fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
}
