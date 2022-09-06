//
//  CoreDataStore.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-05.
//

import Foundation
import CoreData

enum StorageType {
    case persistent, inMemory
}

open class CoreDataStore {
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
    
    public func newDerivedContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        return context
    }
    
    public func saveContext(_ context: NSManagedObjectContext) {
        if context != mainContext {
            saveDerivedContext(context)
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.saveContext(self.mainContext)
        }
    }
}
