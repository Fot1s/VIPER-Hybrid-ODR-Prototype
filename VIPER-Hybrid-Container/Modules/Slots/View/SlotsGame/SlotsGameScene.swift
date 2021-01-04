//
//  SlotsGameScene.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit



class SlotsGameScene: SKScene {
    
    var cardTextures = [SKTexture]()

    var slotMachine:SlotMachine?
    
    var gameRunning = false ;
    
    //game init
    override func didMove(to view: SKView) {
        
        for i in 0...8 {//inclusive is 9
            cardTextures.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
        }

//        let yourline = SKShapeNode()
//        let pathToDraw = CGMutablePath()
//        pathToDraw.move(to: CGPoint(x: self.frame.minX, y: self.frame.maxY))
//        pathToDraw.addLine(to: CGPoint(x: 100.0, y: self.frame.maxY))
//        yourline.path = pathToDraw
//        yourline.strokeColor = SKColor.white
//        addChild(yourline)
        
        self.slotMachine = SlotMachine(frame: CGRect(origin:CGPoint( x:self.frame.minX+8,y:self.frame.maxY - 16), size:CGSize(width:self.frame.width-16,height:self.frame.height - 16)), numberOfColumns: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing, numberOfRows: Constants.Slots.Game.rows, slotsStartAtIndex:0, spinDirection: .downwards)
        
        self.slotMachine?.addCardsToScene(scene: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !(slotMachine?.isRunning ?? false)  {
            startGame()
        }
    }
    
    var lastTimeRun:TimeInterval = 0
    var delta: CFTimeInterval = 0
    
    override func update(_ currentTime: TimeInterval) {

        if (gameRunning) {
            delta = currentTime - lastTimeRun
            slotMachine?.update(timeDelta: delta)
        }

        lastTimeRun = currentTime
    }
    
    func startGame() {
        gameRunning = true
        print("Start Game Called!")
        
        slotMachine?.spinNow(runForTimes: [10,10,10,10,10]) { [weak self] in

            self?.gameRunning = false

            print("Game finished!")
        }
    }
}
