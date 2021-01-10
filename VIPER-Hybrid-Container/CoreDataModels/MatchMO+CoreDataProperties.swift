//
//  MatchMO+CoreDataProperties.swift
//  
//
//  Created by Demitri Delinikolas on 10/01/2021.
//
//

import Foundation
import CoreData

extension MatchMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchMO> {
        return NSFetchRequest<MatchMO>(entityName: "MatchMO")
    }

    @NSManaged public var away: String?
    @NSManaged public var awayGoals: Int16
    @NSManaged public var bet1: Int16
    @NSManaged public var bet2: Int16
    @NSManaged public var betX: Int16
    @NSManaged public var date: String?
    @NSManaged public var home: String?
    @NSManaged public var homeGoals: Int16
    @NSManaged public var id: Int32
    @NSManaged public var live: Int16
    @NSManaged public var time: Int32

}
