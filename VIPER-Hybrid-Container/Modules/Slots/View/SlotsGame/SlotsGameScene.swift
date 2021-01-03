//
//  SlotsGameScene.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit



class SlotsGameScene: SKScene {
    
    var cardTextures = [SKTexture]()

    var slotMachine:SlotMachine?
    
    var slotUp:Slot?
    var slotDown:Slot?

//    var slotMachine:SlotRow?
//    var slotMachine2:SlotRow?
//
    var slotRow:SlotRow?
    var slotRow2:SlotRow?

    var gameRunning = false ;
    
    //game init
    override func didMove(to view: SKView) {
        
        for i in 0...8 {//inclusive is 9
            cardTextures.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
        }

//        print("\(UIScreen.main.scale) \(UIApplication.shared.statusBarFrame.height)")
//        print("\(self.xScale) \(self.yScale)")
//        print("\(self.frame.size)")
        //let barHeight = UIApplication.shared.statusBarFrame.height * 2
//
//        print("White: \(self.frame.maxY - 8)")
//
//        print(UIScreen.main.bounds)
        
        let yourline = SKShapeNode()
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: self.frame.minX, y: self.frame.maxY))
        pathToDraw.addLine(to: CGPoint(x: 100.0, y: self.frame.maxY))
        yourline.path = pathToDraw
        yourline.strokeColor = SKColor.white
        addChild(yourline)
        
        self.slotMachine = SlotMachine(frame: CGRect(origin:CGPoint( x:self.frame.minX+8,y:self.frame.maxY - 16), size:CGSize(width:self.frame.width-16,height:self.frame.height - 16)), numberOfColumns: 5, columnSpacing: 5, numberOfRows: 2, slotsStartAtIndex:0, spinDirection: .downwards)
        
        self.slotMachine?.addCardsToScene(scene: self)
        
        self.slotUp = Slot(cardTextures, position: CGPoint(x:self.frame.minX+8, y:self.frame.maxY - 216), slotWidth: 100, slotAtIndex: 0, spinDirection: .upwards)

        self.slotUp?.addCardsToScene(self)
        
        self.slotDown = Slot(cardTextures, position: CGPoint(x:self.frame.minX+8 + 108, y:self.frame.maxY - 216), slotWidth: 100, slotAtIndex: 0)
        
        self.slotDown?.addCardsToScene(self)
        
        self.slotRow = SlotRow(frame: CGRect(origin: CGPoint( x:self.frame.minX+8,y:self.frame.maxY - 316), size:CGSize(width:self.frame.width - 16, height: 0)), numberOfSlots: 5, columnSpacing: 8, slotsStartAtIndex: 0)
        
        self.slotRow?.addCardsToScene(scene: self)

        self.slotRow2 = SlotRow(frame: CGRect(origin: CGPoint( x:self.frame.minX+8,y:self.frame.maxY - 416), size:CGSize(width:self.frame.width - 16, height: 0)), numberOfSlots: 5, columnSpacing: 8, slotsStartAtIndex: 0, spinDirection: .upwards)
        
        self.slotRow2?.addCardsToScene(scene: self)
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
        
        slotUp?.spinWheel(10, completion: {
            print("Slot up done!")
        })

        slotDown?.spinWheel(10, completion: {
            print("Slot down done!")
        })
        
        slotRow?.spinNow(runForTimes: [10,10,10,10,10]) {
            print("Slot down done!")
        }

        slotRow2?.spinNow(runForTimes: [10,10,10,10,10]) {
            print("Slot down done!")
        }
        
        slotMachine?.spinNow(runForTimes: [10,10,10,10,10]) { [weak self] in

            self?.gameRunning = false

            print("Game finished!")
        }
    }
}
