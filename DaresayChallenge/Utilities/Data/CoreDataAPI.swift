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
    var importContext: NSManagedObjectContext { get }
    var coreDataStore: CoreDataStore { get }
    
    func save()
    func delete<T: NSManagedObject>(object: T) throws
    func createManagedObject<T: NSManagedObject>(entity: T.Type) -> NSManagedObject
    func fetchObject<T: NSManagedObject>(predicate: NSPredicate, entity: T.Type) throws -> [T]
    func createFetchResultsController<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate?, delegate: NSFetchedResultsControllerDelegate?) throws -> NSFetchedResultsController<T>
    func batchUpdate<T: NSManagedObject>(entity: T.Type, propertiesToUpdate: [AnyHashable: Any], predicate: NSPredicate?) throws
}

final class CoreDataAPI {
    
    // MARK: - Variables
    let managedContext: NSManagedObjectContext
    let importContext: NSManagedObjectContext
    let coreDataStore: CoreDataStore
    
    // MARK: - Init

    init(managedContext: NSManagedObjectContext, importContext: NSManagedObjectContext, coreDataStore: CoreDataStore) {
        self.managedContext = managedContext
        self.importContext = importContext
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
    
    func save() {
        coreDataStore.saveContext(managedContext)
    }
    
    func object(with id: NSManagedObjectID) throws -> NSManagedObject {
        try managedContext.existingObject(with: id)
    }
    
    func delete<T: NSManagedObject>(object: T) throws {
        managedContext.delete(object)
    }
    
    func fetchObject<T: NSManagedObject>(predicate: NSPredicate, entity: T.Type) throws -> [T] {
        let fetchRequest = T.fetchRequest()

        fetchRequest.predicate = predicate
        
        let objects = try managedContext.fetch(fetchRequest) as! [T]
        return objects
    }
    
    func createFetchResultsController<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate?, delegate: NSFetchedResultsControllerDelegate?) -> NSFetchedResultsController<T> {
        let entityName = String(describing: entity)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.fetchBatchSize = 20
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController<T>(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = delegate
        fetchedResultsController.fetchRequest.predicate = predicate
        
        return fetchedResultsController
    }
    
    func batchUpdate<T: NSManagedObject>(entity: T.Type, propertiesToUpdate: [AnyHashable : Any], predicate: NSPredicate?) throws {
        let entityDescription = generate(entity: entity)
        
        let updateBatchRequest = NSBatchUpdateRequest(entity: entityDescription)
        updateBatchRequest.predicate = predicate
        updateBatchRequest.propertiesToUpdate = propertiesToUpdate
        updateBatchRequest.resultType = .updatedObjectIDsResultType
        
        let result = try managedContext.execute(updateBatchRequest) as? NSBatchUpdateResult
        
        guard let objectIDArray = result?.result as? [NSManagedObjectID] else { return }
        let changes = [NSUpdatedObjectsKey : objectIDArray]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [managedContext])
    }
}
