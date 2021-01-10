//
//  StoreProtocols.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 10/01/2021.
//  Copyright © 2021 Fotis Chatzinikos. All rights reserved.
//

import CoreData

protocol ViperStore {
    
//    var errorHandler: (Error) -> Void {get set}
//    var persistentContainer: NSPersistentContainer {get}
//    var viewContext: NSManagedObjectContext {get}
//    var backgroundContext: NSManagedObjectContext {get}
//    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
//    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    
    func delete<Entity: ManagedObjectConvertible> (_ type: Entity.Type)
    
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate?,
         sortDescriptors: [NSSortDescriptor]?,
         fetchLimit: Int?,
         completion: @escaping ([Entity]?, Error?) -> Void)
    
    func upsert<Entity: ManagedObjectConvertible>
        (entities: [Entity],
         completion: @escaping (Error?) -> Void)
}

protocol ManagedObjectProtocol {
    associatedtype Entity
    func toEntity() -> Entity?
}

protocol ManagedObjectConvertible {
    associatedtype ManagedObject: NSManagedObject, ManagedObjectProtocol
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject?
}
