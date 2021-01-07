//
//  Constants.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 26/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import UIKit

extension Constants {

    enum Slots {
        enum Game {
            //The SlotMachine card/slot ratio
            static let cellGraphicRatioWidthToHeight = CGFloat(1.092)

            static let columns: Int = 5
            static let rows: Int = 3
            static let columnSpacing: CGFloat = 8

            //time that takes for a card to move to the next slot
            static let timePerCard: CGFloat = 0.05

            //time that takes for a credit card to move to the next slot
            static let timePerCreditNumber: CGFloat = 0.25

            //how much does it cost to play a game
            static let creditsPerGame: Int = 50

            //How many times will a Slot Row run
            //for example:
            //rollForAMinimumOf = Int(20) and addToMinimumRollARandomWithMax = Int(10)
            //will roll the column between 20 and 30 times

            static let rollForAMinimumOf: UInt32 = 20
            static let addToMinimumRollARandomWithMax: UInt32 = 10
        }
    }
}
