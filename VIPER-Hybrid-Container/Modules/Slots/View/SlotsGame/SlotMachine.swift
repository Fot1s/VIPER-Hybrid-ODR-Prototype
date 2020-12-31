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
//    let slotWidth:CGFloat
//    let slotHeight:CGFloat

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
        
        print("Green: \(-200)")
        let yourline3 = SKShapeNode()
        let pathToDraw3 = CGMutablePath()
        pathToDraw3.move(to: CGPoint(x: self.frame.minX, y: frame.origin.y - frame.size.height + 30)) 
        pathToDraw3.addLine(to: CGPoint(x: 100.0, y: frame.origin.y - frame.size.height + 30))        //30 in iphone 80 in  ipad?
        yourline3.path = pathToDraw3
        yourline3.strokeColor = SKColor.green
        scene.addChild(yourline3)

    }
}

