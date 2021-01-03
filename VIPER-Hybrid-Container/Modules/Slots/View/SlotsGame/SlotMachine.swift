//
//  SlotMachine.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 30/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotMachine {
    var cardTextures:[SKTexture]

    var slotColumnsArray:[SlotColumn]
    var slotColumnsRunning:[Bool]

    let numberOfColumns:Int
    let numberOfRows:Int
    let frame: CGRect
    let columnSpacing:CGFloat
    
    var isRunning: Bool {
        get {
            //if any slot is still running return true
            var varToReturn = false ;
            
            for slotRunning in slotColumnsRunning {
                varToReturn = varToReturn || slotRunning
            }
            
            return varToReturn
        }
        set(newValue) {
            for i in 0..<numberOfColumns {
                slotColumnsRunning[i] = newValue
            }
        }
    }

    init(frame:CGRect, numberOfColumns:Int, columnSpacing:CGFloat, numberOfRows:Int ) {
        self.frame = frame ;
        self.numberOfColumns = numberOfColumns
        self.numberOfRows = numberOfRows
        self.columnSpacing = columnSpacing

        var columnSpaces:CGFloat = 0

        cardTextures = [SKTexture]()
        for i in 0...8 {//inclusive is 9
            cardTextures.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
        }

        if (numberOfColumns > 1) {
            columnSpaces = CGFloat(numberOfColumns-1) * columnSpacing
        }

        let slotWidth = (self.frame.size.width - columnSpaces) / CGFloat(numberOfColumns)
        var slotHeight = slotWidth / Constants.Slots.Game.cellGraphicRatioWidthToHeight
        
        if (slotHeight * CGFloat(numberOfRows) > frame.size.height) {
            print("fixed height")
            slotHeight = (frame.size.height - 32) / CGFloat(numberOfRows)
        }
        
        slotColumnsArray = [SlotColumn]()
        slotColumnsRunning = [Bool]()

        for i in 0..<numberOfColumns {
            slotColumnsArray.append(SlotColumn(numberOfRows, cardTextures: cardTextures, position: CGPoint(x:frame.origin.x + CGFloat(i) * (slotWidth+columnSpacing), y:frame.origin.y), slotWidth: slotWidth, slotHeight: slotHeight))
            slotColumnsRunning.append(false)
        }
    }
    
    func addCardsToScene(scene: SKScene) {
        for slotCol in self.slotColumnsArray {
            slotCol.addCardsToScene(scene) 

        }
        
        let yourline2 = SKShapeNode()
        let pathToDraw2 = CGMutablePath()
        pathToDraw2.move(to: CGPoint(x: self.frame.minX, y: self.frame.origin.y))
        pathToDraw2.addLine(to: CGPoint(x: 100.0, y: self.frame.origin.y))
        yourline2.path = pathToDraw2
        yourline2.strokeColor = SKColor.red
        scene.addChild(yourline2)

        let yourline3 = SKShapeNode()
        let pathToDraw3 = CGMutablePath()
        pathToDraw3.move(to: CGPoint(x: self.frame.minX, y: frame.origin.y - frame.size.height))
        pathToDraw3.addLine(to: CGPoint(x: 100.0, y: frame.origin.y - frame.size.height))        //30 in iphone 80 in  ipad?
        yourline3.path = pathToDraw3
        yourline3.strokeColor = SKColor.green
        scene.addChild(yourline3)

    }
    
    func spinNow(runForTimes:[UInt32], completion: @escaping() -> Void) {
        isRunning = true ;
        
        for (index, slotColumn) in slotColumnsArray.enumerated() {
            slotColumn.spinWheel(runForTimes[index]) {
                self.slotColumnsRunning[index] = false
                
                if !self.isRunning {
                    completion()
                }
            }
        }
    }
    
    func update(timeDelta:TimeInterval) {
        for slotColumn in slotColumnsArray {
            slotColumn.update(timeDelta: timeDelta)
        }

    }
}

