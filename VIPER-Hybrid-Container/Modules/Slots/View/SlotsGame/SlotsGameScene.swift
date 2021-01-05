//
//  SlotsGameScene.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit



class SlotsGameScene: SKScene {
    
    var slotMachine:SlotMachine?
    
    var creditsSlotRow:SlotRow?
    
    var gameRunning = false ;
    
    var spinButton:SKSpriteNode?
    
    var score = 100

    
    //game init
    override func didMove(to view: SKView) {
        
        var numberTextures = [SKTexture]()
        for i in 0...9 {//inclusive is 10
            numberTextures.append(SKSpriteNode(imageNamed: "number\(i)").texture!)
        }
        
        //header - score
        let creditsLabel = SKSpriteNode(imageNamed: "credits")
        //credits.size = CGSize(width:50, height:50)
        creditsLabel.position = CGPoint(x: self.frame.minX + 8 + creditsLabel.size.width/2, y: self.frame.maxY - 8 - creditsLabel.size.height/2)
        //credits.name = "SpinButton"
        self.addChild(creditsLabel)

        self.creditsSlotRow = SlotRow(frame: CGRect(origin:CGPoint(x: 8 + creditsLabel.size.width, y: self.frame.maxY - 8 - creditsLabel.size.height/2), size:CGSize(width: 23*5, height: creditsLabel.size.height)), textures: numberTextures, numberOfSlots: 5, columnSpacing: 0, initialNumber: score, spinDirection: Slot.SpinDirection.downwards)
        self.creditsSlotRow?.addCardsToScene(scene: self)
        
        //main area
        self.slotMachine = SlotMachine(scene: self, frame: CGRect(origin:CGPoint( x:self.frame.minX+8,y:self.frame.maxY - 8 - 58), size:CGSize(width:self.frame.width-16,height:self.frame.height - 16 - 58 - 58)), numberOfColumns: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing, numberOfRows: Constants.Slots.Game.rows, slotsStartAtIndex:0, spinDirection: .downwards)
        
        self.slotMachine?.addCardsToScene(scene: self)

        //footer - spin button
        spinButton = SKSpriteNode(imageNamed: "spinButton")
        spinButton?.size = CGSize(width:50, height:50)
        spinButton?.position = CGPoint(x: self.frame.maxX - 25 - 8, y: self.frame.minY + 25 + 8)
        spinButton?.name = "SpinButton"
        self.addChild(spinButton!)

//        let yourline = SKShapeNode()
//        let pathToDraw = CGMutablePath()
//        pathToDraw.move(to: CGPoint(x: self.frame.minX, y: self.frame.maxY))
//        pathToDraw.addLine(to: CGPoint(x: 100.0, y: self.frame.maxY))
//        yourline.path = pathToDraw
//        yourline.strokeColor = SKColor.white
//        addChild(yourline)
        


        
        //FIX:
        //TODO: Move the overlay into a an apropriate method
//overlay tests
//        let overlay = SKSpriteNode(color: UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5), size: CGSize(width:self.frame.width,height:self.frame.height/3))
//
//        overlay.position = CGPoint(x: self.frame.midX - self.frame.width, y: self.frame.midY)
//
//        let label = SKLabelNode(text: "Multi\n    Win!")
//        label.numberOfLines = 2
//        label.fontSize = 72
//        label.fontName = label.fontName! + "-Bold"
//        label.position = CGPoint(x: 0, y: -label.frame.size.height/2)
//        overlay.addChild(label)
//
//        self.addChild(overlay)
//
//        let bringIn = SKAction.move(to: CGPoint(x: self.frame.midX, y: overlay.position.y), duration: TimeInterval(0.5))
//
//        let waitForABit = SKAction.wait(forDuration: 0.5)
//
//        let throwOut = SKAction.move(to: CGPoint(x: self.frame.midX + overlay.frame.size.width, y: overlay.position.y), duration: TimeInterval(0.5))
//
//        let resetToInitialPos = SKAction.run({
//            overlay.position = CGPoint(x: self.frame.midX - self.frame.width, y: self.frame.midY)
//        })
//
//        let sequence = SKAction.sequence([bringIn,waitForABit,throwOut, resetToInitialPos])
//
//        overlay.run(SKAction.sequence([sequence,sequence,sequence]))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "SpinButton" {
                if !(slotMachine?.isRunning ?? false)  {
                    startGame()
                }
            }
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
        
        spinButton?.removeFromParent()

        //if next move goes bellow 0 (credits) stop and
        //TODO: Add game over screen / recharge
        if (score - 50 < 0) {
            return
        }

        gameRunning = true
        print("Start Game Called!")
        
        var runFor = [UInt32]()
        
        for _ in 1...(slotMachine?.numberOfColumns ?? 10) {
            runFor.append(20 + arc4random_uniform(10)) // 10 to 20
        }

        self.score -= 50 ;

        creditsSlotRow?.spinTo(score) {
            
        }
        
        slotMachine?.spinNow(runForTimes: runFor) { [weak self] score in

//            if let safeSelf = self {
//            }
            self?.gameRunning = false

            //if no update to the score enable the spin button now
            //else after the score stops incrementing
            if (score > 0) {
                self?.score += score
                self?.creditsSlotRow?.spinTo((self?.score)!){
                    if let spinButton = self?.spinButton {
                        self?.addChild(spinButton)
                    }
                }
            } else {
                if let spinButton = self?.spinButton {
                    self?.addChild(spinButton)
                }

            }
        }
    }
}

extension String {
    var digits: [Int] {
        return self.flatMap { Int(String($0)) }
    }
}
