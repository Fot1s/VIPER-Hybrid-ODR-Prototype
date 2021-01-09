//
//  StoreService.swift
//  Todolist
//
//  Created by Filipe Santos on 14/07/2020.
//  Copyright © 2020 Pixelmatters. All rights reserved.
//

import CoreData

protocol StoreServiceType: class {
    func getContext() -> NSManagedObjectContext
}

class StoreService {
    private let container: NSPersistentContainer
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

extension StoreService: StoreServiceType {
    func getContext() -> NSManagedObjectContext {
        return self.container.viewContext
    }
}
