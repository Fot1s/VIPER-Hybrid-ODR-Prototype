//
//  ViperStoreExtension.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 10/01/2021.
//  Copyright © 2021 Fotis Chatzinikos. All rights reserved.
//

import Foundation

extension ViperStore {
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate? = nil,
         sortDescriptors: [NSSortDescriptor]? = nil,
         fetchLimit: Int? = nil,
         completion: @escaping ([Entity]?, Error?) -> Void) {
        get(with: nil, sortDescriptors: nil, fetchLimit: nil) { entityArray, error in
            completion(entityArray, error)
        }
    }

}
