//
//  SlotsGameScene.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit



class SlotsGameScene: SKScene {
    
    var slotMachine:SlotRow?
    var slotMachine2:SlotRow?
    var slotMachine3:SlotRow?

    var gameRunning = false ;
    
    //game init
    override func didMove(to view: SKView) {
        
        self.slotMachine = SlotRow(frame: CGRect(origin:CGPoint(x: self.frame.minX,y: self.frame.maxY - 240),size:CGSize(width:self.frame.width,height:50)), numberOfSlots: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing)

        self.slotMachine2 = SlotRow(frame: CGRect(origin:CGPoint(x: self.frame.minX,y: self.frame.maxY - 140),size:CGSize(width:self.frame.width,height:50)), numberOfSlots: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing, slotsStartAtIndex: 1)

        self.slotMachine3 = SlotRow(frame: CGRect(origin:CGPoint(x: self.frame.minX,y: self.frame.maxY - 40),size:CGSize(width:self.frame.width,height:50)), numberOfSlots: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing, slotsStartAtIndex: 2)

        
        self.slotMachine?.addCardsToScene(scene: self)
        self.slotMachine2?.addCardsToScene(scene: self)
        self.slotMachine3?.addCardsToScene(scene: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!(slotMachine?.isRunning ?? true)) {
            startGame()
        }
    }
    
    
    var lastTimeRun:TimeInterval = 0
    var delta: CFTimeInterval = 0
    
//    override func update(_ currentTime: TimeInterval) {
//
//        if (gameRunning) {
//            delta = currentTime - lastTimeRun
//            slotMachine?.update(timeDelta: delta)
//            slotMachine2?.update(timeDelta: delta)
//            slotMachine3?.update(timeDelta: delta)
//        }
//
//        lastTimeRun = currentTime
//    }
    
    func startGame() {
        gameRunning = true
        print("Start Game Called!")

        let runFor:[UInt32] = [UInt32(30 + arc4random_uniform(50)),UInt32(30 + arc4random_uniform(50)),UInt32(30 + arc4random_uniform(50))]
        
        print("Run for: \(runFor)")

        
        slotMachine?.spinNow(runForTimes: runFor) {
            print("Game finished!")
            self.gameRunning = false ;
        }
        slotMachine2?.spinNow(runForTimes: runFor) {
            print("Game finished!")
            self.gameRunning = false ;
        }
        slotMachine3?.spinNow(runForTimes: runFor) {
            print("Game finished!")
            self.gameRunning = false ;
        }
    }
}
