//
//  MatchUpdate.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation



struct MatchUpdate:Codable {

    enum UpdateFor: Int,Codable {
        case Home = 1
        case Draw = 2
        case Away = 3
    }

    var id = 0
    var updateFor = UpdateFor.Draw
    var value = 0
}

