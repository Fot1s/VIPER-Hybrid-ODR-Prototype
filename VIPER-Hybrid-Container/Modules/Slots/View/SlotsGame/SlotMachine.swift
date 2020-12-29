////
////  SlotMachine.swift
////  VIPER-Hybrid-Container
////
////  Created by Demitri Delinikolas on 30/12/2020.
////  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
////
//
//import SpriteKit
//
//class SlotMachine {
//    var cardTextures:[SKTexture]
//
//    var slotRowsArray:[Slot]
//    var slotRowsRunning:[Bool]
//
//    let numberOfRows:Int
//    let frame: CGRect
//    let rowSpacing:CGFloat
//    let columnSpacing:CGFloat
//    let slotWidth:CGFloat
//    let slotHeight:CGFloat
//
//    init(frame:CGRect, numberOfRows:Int, rowSpacing:CGFloat, columnSpacing:CGFloat ) {
//        self.frame = frame ;
//        self.numberOfRows = numberOfRows
//        self.rowSpacing = rowSpacing
//        self.columnSpacing = columnSpacing
//
//        var rowSpaces:CGFloat = 0
//
//        cardTextures = [SKTexture]()
//        for i in 0...8 {//inclusive is 9
//            cardTextures.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
//        }
//
//        if (numberOfRows > 1) {
//            rowSpaces = CGFloat(numberOfRows-1) * rowSpacing
//        }
//
//        slotHeight = (self.frame.size.height - rowSpaces) / CGFloat(numberOfRows)
//
//
//        slotRowsArray = [Slot]()
//        slotRowsRunning = [Bool]()
//
//        for i in 0..<numberOfRows {
//            slotRowsArray.append(SlotRow(textures: cardTextures, position: CGPoint(x:frame.origin.x + CGFloat(i) * (slotWidth+columnSpacing),y:frame.origin.y),slotWidth: slotWidth, slotAtIndex: i))
//            slotRowsRunning.append(false)
//        }
//    }
//}

