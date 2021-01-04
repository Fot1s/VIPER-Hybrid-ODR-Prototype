//
//  MatchUpdate.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation



struct MatchUpdate:Codable {

    enum BetType: Int,Codable {
        case Home = 1
        case Draw = 2
        case Away = 3
    }

    var id = 0
    var updateFor = BetType.Draw
    var value = 0
}

extension Match {
    
    mutating func updateMatchBetFromMatchUpdate(_ updatedMatch:MatchUpdate) {
        switch (updatedMatch.updateFor) {
        case .Home :
            self.bet1 = updatedMatch.value
        case .Draw :
            self.betX = updatedMatch.value
        case .Away :
            self.bet2 = updatedMatch.value
        }
    }
    
    func getBetValueForBetType(_ update:MatchUpdate.BetType) -> Int {
        switch update {
        case .Home :
            return self.bet1
        case .Draw :
            return self.betX
        case .Away :
            return self.bet2
        }
    }

}
