//
//  CoreDataStore.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-05.
//

import Foundation
import CoreData

protocol CoreDataStorable {
    var mainContext: NSManagedObjectContext { get }
    
    func newDerivedContext() -> NSManagedObjectContext
    func saveContext(_ context: NSManagedObjectContext)
}

enum StorageType {
    case persistent, inMemory
}

open class CoreDataStore {
    
    // MARK: - Variables
    public let persistentContainer: NSPersistentContainer
    
    public static let modelName = "MovieDataStore"
    
    public static let model: NSManagedObjectModel = {
        // swiftlint:disable force_unwrapping
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Init
    init(_ storageType: StorageType = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: CoreDataStore.modelName, managedObjectModel: CoreDataStore.model)
        
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.persistentContainer.persistentStoreDescriptions = [description]
        }
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

// MARK: - CoreDataStorable
extension CoreDataStore: CoreDataStorable {
    func newDerivedContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        return context
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
