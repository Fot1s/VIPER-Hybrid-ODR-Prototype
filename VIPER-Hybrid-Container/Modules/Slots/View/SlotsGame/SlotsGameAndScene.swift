//
//  SlotsGameScene.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotsGameAndScene: SKScene {

    var slotMachine: SlotMachine?

    var creditsSlotRow: SlotRow?

    var gameRunning = false

    var spinButton: SKSpriteNode?
    var spinAllButton: SKSpriteNode?
    var spinCancelButton: SKSpriteNode?
    var noMoreCreditsOverlay: SKSpriteNode?

    //TODO: Credits can go up to 99999 at the moment before issues
    //- fixable if needed from easy to hard: more digits, auto smaller font and increase in digits, scientific anotation, ++

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
        creditsLabel.position = CGPoint(x: self.frame.minX + 8 + creditsLabel.size.width/2,
                                        y: self.frame.maxY - 8 - creditsLabel.size.height/2)
        //credits.name = "SpinButton"
        self.addChild(creditsLabel)

        self.creditsSlotRow = SlotRow(frame: CGRect(origin: CGPoint(x: self.frame.maxX - 8 - 23*5,
                                                                   y: self.frame.maxY - 8),
                                                    size: CGSize(width: 23*5, height: creditsLabel.size.height)),
                                      textures: numberTextures, scene: self,
                                      numberOfSlots: 5, columnSpacing: 0,
                                      widthToHightRatio: 0.4792,
                                      initialNumber: score, spinDirection: Slot.SpinDirection.downwards)

        //main area
        self.slotMachine = SlotMachine(frame: CGRect(origin: CGPoint( x: self.frame.minX+8, y: self.frame.maxY - 8 - 58),
                                                     size: CGSize(width: self.frame.width-16, height: self.frame.height - 16 - 58 - 58)),
                                       scene: self,
                                       numberOfColumns: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing,
                                       numberOfRows: Constants.Slots.Game.rows, slotsStartAtIndex: 0, spinDirection: .downwards)

        //footer - spin button
        spinButton = SKSpriteNode(imageNamed: "spinButton")
        spinButton?.size = CGSize(width: 50, height: 50)
        spinButton?.position = CGPoint(x: self.frame.maxX - 25 - 8, y: self.frame.minY + 25 + 8)
        spinButton?.name = "SpinButton"
        self.addChild(spinButton!)

        spinAllButton = SKSpriteNode(imageNamed: "spinAllButton")
        spinAllButton?.size = CGSize(width: 50, height: 50)
        spinAllButton?.position = CGPoint(x: self.frame.minX + 25 + 8, y: self.frame.minY + 25 + 8)
        spinAllButton?.name = "SpinButtonAll"

        spinCancelButton = SKSpriteNode(imageNamed: "spinCancelButton")
        spinCancelButton?.size = CGSize(width: 50, height: 50)
        spinCancelButton?.position = CGPoint(x: self.frame.minX + 25 + 8, y: self.frame.minY + 25 + 8)
        spinCancelButton?.name = "SpinButtonAll"

        self.addChild(spinAllButton!)

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

        let label = SKLabelNode(text: "No More\n  Credits!")
        label.numberOfLines = 2
        label.color = UIColor.white
        label.fontSize = 64
        //If we need a font we need to try a system font or load a custom one
        //SKLabelNode: "HelveticaNeue-UltraLight-Bold" font not found.
        //label.fontName = label.fontName! + "-Bold"
        label.position = CGPoint(x: 0, y: -label.frame.size.height/2)

        noMoreCreditsOverlay = SKSpriteNode(color: UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5),
                                            size: CGSize(width: self.frame.width, height: label.frame.size.height + 100))

        noMoreCreditsOverlay?.position = CGPoint(x: self.frame.midX - self.frame.width, y: self.frame.midY)
        noMoreCreditsOverlay?.zPosition = 1000

        noMoreCreditsOverlay?.addChild(label)

        //self.addChild(overlay)
    }

    var spinAll = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "SpinButton" {
                if !(slotMachine?.isRunning ?? false) {
                    spinAll = false
                    spinButton?.removeFromParent()
                    spinAllButton?.removeFromParent()

                    startGame()
                }
            } else if touchedNode.name == "SpinButtonAll" {
                if spinAll {
                    spinAll = false
                    spinCancelButton?.removeFromParent()
                } else {
                    if !(slotMachine?.isRunning ?? false) {
                        spinAll = true
                        spinAllButton?.removeFromParent()
                        spinButton?.removeFromParent()
                        self.addChild(spinCancelButton!)
                        startGame()
                    }
                }
            }
        }
    }

    var lastTimeRun: TimeInterval = 0
    var delta: CFTimeInterval = 0

    override func update(_ currentTime: TimeInterval) {

        if gameRunning {
            delta = currentTime - lastTimeRun
            slotMachine?.update(timeDelta: delta)
        }

        lastTimeRun = currentTime
    }

    func startGame() {

        //if next move goes bellow 0 (credits) stop and
        //TODO: Add game over screen / recharge
        if score - 50 < 0 {
            return
        }

        gameRunning = true
        print("Start Game Called!")

        var runFor = [UInt32]()

        for _ in 1...(slotMachine?.numberOfColumns ?? 10) {
            runFor.append(17 + arc4random_uniform(10)) // 10 to 20
        }

        self.score -= 50

        creditsSlotRow?.spinTo(score) {

        }

        slotMachine?.spinNow(runForTimes: runFor) { [weak self] scoreToAdd in

//            if let safeSelf = self {
//            }
            self?.gameRunning = false

            //if no update to the score enable the spin button now
            //else after the score stops incrementing
            if scoreToAdd > 0 {
                self?.score += scoreToAdd
                self?.creditsSlotRow?.spinTo((self?.score)!) {

                    if self?.spinAll == true && (self!.score - 50) >= 0 {

                        DispatchQueue.main.async {
                            self?.startGame()
                        }
                        return
                    }

                    if self!.score - 50 >= 0 {
                        if let spinButton = self?.spinButton {
                            self?.addChild(spinButton)
                        }
                        if let spinAllButton = self?.spinAllButton, spinAllButton.parent == nil {
                            self?.addChild(spinAllButton)
                        }

                    } else {
                        self?.showNoMoreCredits()
                    }
                }
            } else {
                if self?.spinAll == true && (self!.score - 50) >= 0 {

                    DispatchQueue.main.async {
                        self?.startGame()
                    }
                    return
                }

                if self!.score - 50 >= 0 {
                    if let spinButton = self?.spinButton {
                        self?.addChild(spinButton)
                    }
                    if let spinAllButton = self?.spinAllButton, spinAllButton.parent == nil {
                        self?.addChild(spinAllButton)
                    }
                } else {
                    self?.showNoMoreCredits()
                }
            }
        }
    }

    func showNoMoreCredits() {

        spinAllButton?.removeFromParent()
        spinCancelButton?.removeFromParent()

        if let creditsOverlay = self.noMoreCreditsOverlay {
            self.addChild(creditsOverlay)
            let bringIn = SKAction.move(to: CGPoint(x: self.frame.midX, y: creditsOverlay.position.y), duration: TimeInterval(0.5))

//            let waitForABit = SKAction.wait(forDuration: 2.0)

//            let throwOut = SKAction.move(to: CGPoint(x: self.frame.midX + creditsOverlay.frame.size.width, y: creditsOverlay.position.y),
//                                         duration: TimeInterval(0.5))
//
//            let resetToInitialPos = SKAction.run({
//                self.noMoreCreditsOverlay?.position = CGPoint(x: self.frame.midX - self.frame.width, y: self.frame.midY)
//                self.noMoreCreditsOverlay?.removeFromParent()
//            })

            creditsOverlay.run(SKAction.sequence([bringIn])) // , waitForABit, throwOut, resetToInitialPos
        }
    }
}

extension String {
    var digits: [Int] {
        return self.flatMap { Int(String($0)) }
    }
}
