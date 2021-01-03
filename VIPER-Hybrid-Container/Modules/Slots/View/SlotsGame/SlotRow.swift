//
//  SlotMachine.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 29/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotRow {
    var cardTextures:[SKTexture]
    
    var slotsArray:[Slot]
    var slotsRunning:[Bool]

    let numberOfSlots:Int
    let frame: CGRect
    let columnSpacing:CGFloat
    let slotWidth:CGFloat
    let slotsStartAtIndex:Int
    
    var isRunning: Bool {
        get {
            //if any slot is still running return true
            var varToReturn = false ;
            
            for slotRunning in slotsRunning {
                varToReturn = varToReturn || slotRunning
            }
            
            return varToReturn
        }
        set(newValue) {
            for i in 0..<numberOfSlots {
                slotsRunning[i] = newValue
            }
        }
    }
    
    init(frame:CGRect, numberOfSlots:Int, columnSpacing:CGFloat, slotsStartAtIndex:Int = 0, spinDirection:Slot.SpinDirection = .downwards ) {
        self.frame = frame ;
        self.numberOfSlots = numberOfSlots
        self.columnSpacing = columnSpacing
        self.slotsStartAtIndex = slotsStartAtIndex
        
        var columnSpaces:CGFloat = 0
        
        if (numberOfSlots > 1) {
            columnSpaces = CGFloat(numberOfSlots-1) * columnSpacing
        }
        
        slotWidth = (self.frame.size.width - columnSpaces) / CGFloat(numberOfSlots)
        
        cardTextures = [SKTexture]()
        for i in 0...8 {//inclusive is 9
            cardTextures.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
        }
      
        slotsArray = [Slot]()
        slotsRunning = [Bool]()
        
        for i in 0..<numberOfSlots {
            slotsArray.append(Slot(cardTextures,position: CGPoint(x:frame.origin.x + CGFloat(i) * (slotWidth+columnSpacing),y:frame.origin.y),slotWidth: slotWidth, slotAtIndex: slotsStartAtIndex, spinDirection: spinDirection))
            slotsRunning.append(false)
        }
    }
    
    func addCardsToScene(scene: SKScene) {
        
        for slot in slotsArray {
            slot.addCardsToScene(scene)
        }
    }

    func remCardsFromScene() {
        
        for slot in slotsArray {
            slot.remCardsFromScene()
        }
    }

    
    func spinNow(runForTimes:[UInt32], completion: @escaping() -> Void) {
        isRunning = true ;
        
        for (index, slot) in slotsArray.enumerated() {
            slot.spinWheel(runForTimes[index]) {
                self.slotsRunning[index] = false
                
                if !self.isRunning {
                    completion()
                }
            }
        }
    }
    
//    func update(timeDelta:TimeInterval) {
//        for slot in slotsArray {
//            slot.update(timeDelta: timeDelta)
//        }
//    }
}
