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

//    var slotMachine:SlotRow?
//    var slotMachine2:SlotRow?
//
//    var slotColumn:SlotColumn?
//    var slotColumn2:SlotColumn?

    
    
    var gameRunning = false ;
    
    //game init
    override func didMove(to view: SKView) {
        
        for i in 0...8 {//inclusive is 9
            cardTextures.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
        }

        
        print("\(UIScreen.main.scale) \(UIApplication.shared.statusBarFrame.height)")
        print("\(self.xScale) \(self.yScale)")
        print("\(self.frame.size)")
        //let barHeight = UIApplication.shared.statusBarFrame.height * 2

        print("White: \(self.frame.maxY - 8)")

        print(UIScreen.main.bounds)
        
        
        let yourline = SKShapeNode()
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: self.frame.minX, y: self.frame.maxY))
        pathToDraw.addLine(to: CGPoint(x: 100.0, y: self.frame.maxY))
        yourline.path = pathToDraw
        yourline.strokeColor = SKColor.white
        addChild(yourline)



        
        self.slotMachine = SlotMachine(frame: CGRect(origin:CGPoint( x:self.frame.minX+8,y:self.frame.maxY - 16), size:CGSize(width:self.frame.width-16,height:self.frame.height - 16)), numberOfColumns: 5, columnSpacing: 5, numberOfRows: 5)
        
        self.slotMachine?.addCardsToScene(scene: self)
        
//        self.slotColumn = SlotColumn(4, cardTextures: cardTextures, position: CGPoint(x:-100,y:self.frame.maxY - 144), slotWidth: 70, slotHeight: 60)
//
//        self.slotColumn2 = SlotColumn(4, cardTextures: cardTextures, position: CGPoint(x:0 ,y:self.frame.maxY - 144), slotWidth: 70, slotHeight: 60)
//
//
//        self.slotMachine = SlotRow(frame: CGRect(origin:CGPoint(x: self.frame.minX,y: self.frame.maxY - 40),size:CGSize(width:self.frame.width,height:50)), numberOfSlots: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing)
//
//        self.slotMachine2 = SlotRow(frame: CGRect(origin:CGPoint(x: self.frame.minX,y: self.frame.maxY - 140),size:CGSize(width:self.frame.width,height:50)), numberOfSlots: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing, slotsStartAtIndex: 1)
//
//        self.slotMachine?.addCardsToScene(scene: self)
//        self.slotMachine2?.addCardsToScene(scene: self)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if slotMachine?.isRunning ?? true {
            startGame()
//        }
    }
    
    
    var lastTimeRun:TimeInterval = 0
    var delta: CFTimeInterval = 0
    
    override func update(_ currentTime: TimeInterval) {

        if (gameRunning) {
            delta = currentTime - lastTimeRun
//            slotColumn?.update(timeDelta: delta)
//            slotColumn2?.update(timeDelta: delta)
        }

        lastTimeRun = currentTime
    }
    
    func startGame() {
        gameRunning = true
        print("Start Game Called!")

//        slotMachine?.spinNow(runForTimes: [20,20,20,20,20]) {
//            print("Game finished!")
////            self.gameRunning = false ;
//        }
//        slotMachine2?.spinNow(runForTimes: [20,20,20,20,20]) {
//            print("Game finished!")
////            self.gameRunning = false ;
//
//            self.slotMachine?.remCardsFromScene()
//            self.slotMachine2?.remCardsFromScene()
//
//            self.slotColumn?.addCardsToScene(scene: self)
//            self.slotColumn2?.addCardsToScene(scene: self)
//
//            self.slotColumn?.spinWheel(20, completion: {
//                print("Column done!")
//            })
//            self.slotColumn2?.spinWheel(20, completion: {
//                print("Column done!")
//            })
//
//        }
//
        
        
//        slotMachine2?.spinNow(runForTimes: runFor) {
//            print("Game finished!")
//            self.gameRunning = false ;
//        }
//        slotMachine3?.spinNow(runForTimes: runFor) {
//            print("Game finished!")
//            self.gameRunning = false ;
//        }
    }
}
