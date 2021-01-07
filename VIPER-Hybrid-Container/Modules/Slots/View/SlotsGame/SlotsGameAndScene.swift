//
//  SlotsGameScene.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotsGameAndScene: SKScene {

    //Sprite nodes slots machine and creditsSlotRow marked as force unwrapped as we initialize all of them in the setupGame bellow
    var slotMachine: SlotMachine!

    var creditsSlotRow: SlotRow!

    var spinButton: SKSpriteNode!
    var spinAllButton: SKSpriteNode!
    var spinCancelButton: SKSpriteNode!
    var noMoreCreditsOverlay: SKSpriteNode!

    var gameRunning = false

    //TODO: Credits can go up to 99999 at the moment before issues
    //- fixable if needed from easy to hard: more digits, auto smaller font and increase in digits, scientific anotation, ++

    //TODO: Get the credits from the user profile via net/socket call
    var score = 100

    var spinAll = false

    var lastTimeRun: TimeInterval = 0
    var delta: CFTimeInterval = 0

    //game init
    override func didMove(to view: SKView) {
        setupGame()
    }

    //process touches here
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)

            if touchedNode.name == "SpinButton" {

                //Spin Once
                //if not running, remove the spin buttons and start the game
                if !slotMachine.isRunning {
                    spinAll = false
                    spinButton?.removeFromParent()
                    spinAllButton?.removeFromParent()

                    startGame()
                }
            } else if touchedNode.name == "SpinButtonAll" {

                //Spin while credits remain / cancel all if already running
                //if already running, stop and remove the button
                //else if not running, remove the spin buttons, add the cancel button and start in spin all mode
                if spinAll {
                    spinAll = false
                    spinCancelButton?.removeFromParent()
                } else {
                    if !slotMachine.isRunning {
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

    //Runs every frame with the currentTime from the start of the app, delta keeps the time from the previous frame
    override func update(_ currentTime: TimeInterval) {

        if gameRunning {
            delta = currentTime - lastTimeRun
            slotMachine?.update(timeDelta: delta)
        }

        lastTimeRun = currentTime
    }

    //Called for the spin bytton after the user taps on one of them to start the SlotMachine
    func startGame() {

        //if next move goes bellow 0 (credits) stop and
        //TODO: Add game over screen / recharge
        if score - 50 < 0 {
            return
        }

        gameRunning = true

        var runFor = [UInt32]()

        for _ in 1...(slotMachine.numberOfColumns) {
            runFor.append(17 + arc4random_uniform(10)) // 10 to 20
        }

        //each time the game is started the user loses 50 credits
        self.score -= 50

        //spin to the new credits
        creditsSlotRow.spinTo(score) {

        }

        slotMachine?.spinNow(runForTimes: runFor) { [weak self] scoreToAdd in

            if let `self` = self {

                //stop the game from running, start will reset it to true if still running from spin all
                self.gameRunning = false

                //increment the score, spin to the new score and when done continue with restarting or ending the game
                //if the score has not changed, and there is no need for animation, creditsSlotRow completes immediately
                self.score += scoreToAdd
                self.creditsSlotRow?.spinTo(self.score) {

                    //if in spin all mode and have more credits continue
                    if self.spinAll == true && self.score - 50 >= 0 {

                        //dispatch a new game start here, to avoid recursion/stack issues
                        DispatchQueue.main.async {
                            self.startGame()
                        }
                        return
                    } else {

                        //Single spin or end of credits
                        if self.score - 50 >= 0 {
                            self.addChild(self.spinButton)
                            self.addChild(self.spinAllButton)
                        } else {
                            self.showNoMoreCredits()
                        }

                    }
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

//Code to throw the game end card out, if for example the user adds credits
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

    //Called from didMove(to view: SKView) to initialize the game elements
    func setupGame() {

        //load credits counter textures
        var numberTextures = [SKTexture]()
        for i in 0...9 {//inclusive is 10
            numberTextures.append(SKSpriteNode(imageNamed: "number\(i)").texture!)
        }

        //Create Header elements
        //the credits label
        let creditsLabel = SKSpriteNode(imageNamed: "credits")
        creditsLabel.position = CGPoint(x: self.frame.minX + 8 + creditsLabel.size.width/2,
                                        y: self.frame.maxY - 8 - creditsLabel.size.height/2)
        self.addChild(creditsLabel)

        //the credits SlotRow
        self.creditsSlotRow = SlotRow(frame: CGRect(origin: CGPoint(x: self.frame.maxX - 8 - 23*5,
                                                                    y: self.frame.maxY - 8),
                                                    size: CGSize(width: 23*5, height: creditsLabel.size.height)),
                                      textures: numberTextures, scene: self,
                                      numberOfSlots: 5, columnSpacing: 0,
                                      widthToHightRatio: 0.4792,
                                      initialNumber: score, spinDirection: Slot.SpinDirection.downwards)

        //Create Main area / Slot Machine
        self.slotMachine = SlotMachine(frame: CGRect(origin: CGPoint( x: self.frame.minX+8, y: self.frame.maxY - 8 - 58),
                                                     size: CGSize(width: self.frame.width-16, height: self.frame.height - 16 - 58 - 58)),
                                       scene: self,
                                       numberOfColumns: Constants.Slots.Game.columns, columnSpacing: Constants.Slots.Game.columnSpacing,
                                       numberOfRows: Constants.Slots.Game.rows, slotsStartAtIndex: 0, spinDirection: .downwards)

        //Create footer

        //the spin button
        spinButton = SKSpriteNode(imageNamed: "spinButton")
        spinButton?.size = CGSize(width: 50, height: 50)
        spinButton?.position = CGPoint(x: self.frame.maxX - 25 - 8, y: self.frame.minY + 25 + 8)
        spinButton?.name = "SpinButton"
        self.addChild(spinButton!)

        //the spin all button
        spinAllButton = SKSpriteNode(imageNamed: "spinAllButton")
        spinAllButton?.size = CGSize(width: 50, height: 50)
        spinAllButton?.position = CGPoint(x: self.frame.minX + 25 + 8, y: self.frame.minY + 25 + 8)
        spinAllButton?.name = "SpinButtonAll"
        self.addChild(spinAllButton!)

        //the cancel spinning (all) button
        //not added to the scene yet, will be added whn spinall is tapped
        spinCancelButton = SKSpriteNode(imageNamed: "spinCancelButton")
        spinCancelButton?.size = CGSize(width: 50, height: 50)
        spinCancelButton?.position = CGPoint(x: self.frame.minX + 25 + 8, y: self.frame.minY + 25 + 8)
        spinCancelButton?.name = "SpinButtonAll"

        //create the End Game/Credits card
        //not added to the scene yet
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
    }
}

/// Adds digits extension to String
///
/// Returns [Int] of the digits in the String
///
/// Only 0-9 are processed and returned - to be sure check that the returned length is same as the incoming String
extension String {
    var digits: [Int] {
        return self.flatMap {
            Int(String($0))
        }
    }
}
