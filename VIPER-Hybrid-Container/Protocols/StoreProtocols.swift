//
//  StoreProtocols.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 10/01/2021.
//  Copyright © 2021 Fotis Chatzinikos. All rights reserved.
//

import CoreData

protocol ViperStore {
    var errorHandler: (Error) -> Void {get set}
    var persistentContainer: NSPersistentContainer {get}
    var viewContext: NSManagedObjectContext {get}
    var backgroundContext: NSManagedObjectContext {get}
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}
