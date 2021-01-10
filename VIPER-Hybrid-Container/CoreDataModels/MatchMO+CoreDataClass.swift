//
//  MatchMO+CoreDataClass.swift
//  
//
//  Created by Fotis Chatzinikos on 10/01/2021.
//
//

import Foundation
import CoreData

@objc(MatchMO)
public class MatchMO: NSManagedObject {

}

extension MatchMO: ManagedObjectProtocol {
    func toEntity() -> Match? {
        return Match(id: Int(id), live: Int(live), time: Int(time), date: date ?? "", home: home ?? "", away: away ?? "",
                     homeGoals: Int(homeGoals), awayGoals: Int(awayGoals), bet1: Int(bet1), betX: Int(betX), bet2: Int(bet2))
    }
}

extension Match: ManagedObjectConvertible {
    
    func toManagedObject(in context: NSManagedObjectContext) -> MatchMO? {
        let match = MatchMO.getOrCreateSingle(with: id, from: context)
        
        match.id = Int32(id)
        match.live = Int16(live)
        match.time = Int32(time)
        match.date = date
        match.home = home
        match.away = away
        match.homeGoals = Int16(homeGoals)
        match.awayGoals = Int16(awayGoals)
        match.bet1 = Int16(bet1)
        match.betX = Int16(betX)
        match.bet2 = Int16(bet2)
        
        return match
    }
}
