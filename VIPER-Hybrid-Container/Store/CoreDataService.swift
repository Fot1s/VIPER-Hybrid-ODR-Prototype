//
//  CoreDataService.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 10/01/2021.
//  Copyright © 2021 Fotis Chatzinikos. All rights reserved.
//

import CoreData

final class CoreDataService: ViperStore {
    
    static let shared = CoreDataService()
    
    var errorHandler: (Error) -> Void = {_ in }
    
    private init() {
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { [weak self](_, error) in //storeDescription
            if let error = error {
                NSLog("CoreData error \(error), \(String(describing: error._userInfo))")
                self?.errorHandler(error)
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let context: NSManagedObjectContext = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
    func delete<Entity: ManagedObjectConvertible> (_ type: Entity.Type) {
        performBackgroundTask { context in
            do {
                let fetchRequest = Entity.ManagedObject.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
                try context.save()
                print("Deleted data!")
            } catch {
                print("Error deleting data!")
            }
        }
    }
    
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate?,
         sortDescriptors: [NSSortDescriptor]?,
         fetchLimit: Int?,
         completion: @escaping ([Entity]?, Error?) -> Void) {
        
        performForegroundTask { context in
            do {
                let fetchRequest = Entity.ManagedObject.fetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                if let fetchLimit = fetchLimit {
                    fetchRequest.fetchLimit = fetchLimit
                }
                let results = try context.fetch(fetchRequest) as? [Entity.ManagedObject]
                
                //FIX: TODO: Was compactMap but does not compile in Swift 4
                let items: [Entity] = results?.flatMap { $0.toEntity() as? Entity } ?? []
                completion(items, nil)
            } catch {
                //let fetchError = CoreDataWorkerError.cannotFetch("Cannot fetch error: \(error))")
                completion(nil, error)
            }
        }
    }
    
    func upsert<Entity: ManagedObjectConvertible>
        (entities: [Entity],
         completion: @escaping (Error?) -> Void) {
        
        performBackgroundTask { context in
            //FIX: TODO: Was compactMap but does not compile in Swift 4
            _ = entities.flatMap({ (entity) -> Entity.ManagedObject? in
                return entity.toManagedObject(in: context)
            })
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
