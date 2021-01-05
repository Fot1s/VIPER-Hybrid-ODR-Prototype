//
//  MatchUpdate.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation

struct MatchUpdate: Codable {

    enum BetType: Int, Codable {
        case home = 1
        case draw = 2
        case away = 3
    }

    var id = 0
    var updateFor = BetType.draw
    var value = 0
}

extension Match {

    mutating func updateMatchBetFromMatchUpdate(_ updatedMatch: MatchUpdate) {
        switch updatedMatch.updateFor {
        case .home :
            self.bet1 = updatedMatch.value
        case .draw :
            self.betX = updatedMatch.value
        case .away :
            self.bet2 = updatedMatch.value
        }
    }

    func getBetValueForBetType(_ update: MatchUpdate.BetType) -> Int {
        switch update {
        case .home :
            return self.bet1
        case .draw :
            return self.betX
        case .away :
            return self.bet2
        }
    }

}
