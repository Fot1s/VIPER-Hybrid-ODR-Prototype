//
//  Slot.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 29/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class Slot {
    
    enum SpinDirection {
        case downwards
        case upwards
    }
    
    let cardTextures:[SKTexture]

    var slotAtIndex:Int
    
    var visibleCard:SKSpriteNode
    var hiddenCard:SKSpriteNode
    
    var slotRunning: Bool
    var cardsAdded: Bool
    
    var position: CGPoint
    var slotWidth: CGFloat
    var slotHeight: CGFloat

    var hiddenPosY: CGFloat
    var visiblePosY: CGFloat
    var limitPosY: CGFloat
    
    var spinDirection:SpinDirection

    init(_ cardTextures:[SKTexture], position:CGPoint, slotWidth:CGFloat, slotAtIndex:Int = 0, spinDirection:SpinDirection = .downwards) {
        
        self.slotRunning = false
        self.cardsAdded = false 
        
        self.cardTextures = cardTextures
        self.position = position
        self.slotWidth = slotWidth
        self.slotHeight = slotWidth / Constants.Slots.Game.cellGraphicRatioWidthToHeight
        
        self.slotAtIndex = slotAtIndex
        self.spinDirection = spinDirection
        
        self.visibleCard = SKSpriteNode(texture: cardTextures[slotAtIndex])
        
        self.visiblePosY = position.y - slotHeight/2
        
        self.visibleCard.position = CGPoint(x:position.x + slotWidth/2 ,y: visiblePosY)
        self.visibleCard.size = CGSize(width: slotWidth, height: slotHeight)

        if (self.spinDirection == .downwards) {
            self.slotAtIndex += 1

            if (self.slotAtIndex >= cardTextures.count) {
                self.slotAtIndex = 0
            }
            
            self.hiddenCard = SKSpriteNode(texture: cardTextures[self.slotAtIndex])
            
            self.hiddenCard.position    = CGPoint(x:position.x + slotWidth/2 ,y: position.y + slotHeight/2)
            
            self.hiddenPosY = hiddenCard.position.y
            self.limitPosY = visibleCard.position.y - slotHeight
            
        } else {
            self.slotAtIndex -= 1
            
            if (self.slotAtIndex <= 0 ) {
                self.slotAtIndex = cardTextures.count - 1
            }

            self.hiddenCard = SKSpriteNode(texture: cardTextures[self.slotAtIndex])
            
            self.hiddenCard.position    = CGPoint(x:position.x + slotWidth/2 ,y: position.y - slotHeight/2 - slotHeight)
            
            self.hiddenPosY = hiddenCard.position.y
            self.limitPosY = visibleCard.position.y + slotHeight
        }
        
        self.hiddenCard.size = CGSize(width: slotWidth, height: slotHeight)
    }
    
    func remCardsFromScene() {
        //remove all - get the parent and remove - parrent contains all cards and the mask
        visibleCard.parent?.removeFromParent()
    }
    
    func addCardsToScene(_ scene: SKScene) {
        
        //create a mask
        let mask = SKSpriteNode(color: SKColor.black, size: CGSize(width: slotWidth, height: slotHeight))
        mask.position = CGPoint(x:position.x + slotWidth/2 ,y: position.y - slotHeight/2)

        //create a container, assign the mask and add the cards to it
        let container = SKCropNode()
        container.maskNode = mask

        container.addChild(visibleCard)
        container.addChild(hiddenCard)
        
        //add the container to the scene
        scene.addChild(container)

        self.cardsAdded = true
    }
    
    func spinWheel(_ count:Int, completion: @escaping() -> Void) {
        
        if (self.slotRunning) {
            print("Already running skip!") //TODO: Could guard this instead of skipping?
            return
        }
        
        guard self.cardsAdded else {
            print("Cards must be added to the scene before spinning!");
            return
        }

        guard count > 0 else {
            print("Will not start with a count of 0!");
            return
        }
        
        self.slotRunning = true
        
        // Determine duration of the card move
        let actualDuration = 1.5 //2.0 / 25 //arc4random_uniform(2) + 2 //(2->4)

        let frameMidX = self.visibleCard.frame.midX
        
        // Create the actions
        let moveVisibleOut = SKAction.move(to: CGPoint(x: frameMidX, y: limitPosY), duration: TimeInterval(actualDuration))

        let moveHiddenToVisible = SKAction.move(to: CGPoint(x: frameMidX, y: visiblePosY),
                                              duration: TimeInterval(actualDuration))


        let jumpVisibleFromOutToVisiblePos = SKAction.run({
            self.visibleCard.texture = self.hiddenCard.texture
            self.visibleCard.position.y = self.visiblePosY

            if (self.spinDirection == .downwards) {
                self.slotAtIndex += 1
                
                if self.slotAtIndex > self.cardTextures.count - 1 {
                    self.slotAtIndex = 0
                }
                self.hiddenCard.texture = self.cardTextures[self.slotAtIndex]
            } else {
                self.slotAtIndex -= 1
                
                if self.slotAtIndex <= 0 {
                    self.slotAtIndex = self.cardTextures.count - 1
                }
                self.hiddenCard.texture = self.cardTextures[self.slotAtIndex]
            }
        })

        let jumpHiddenFromVisibleToHiddenPos = SKAction.run({
            self.hiddenCard.position.y = self.hiddenPosY
        })

        let actionDone = SKAction.run({
            self.slotRunning = false
            
            // jumpVisibleFromOutToVisiblePos changes the index on preperation for next move
            // if last move fix it one back:
            
            if (self.spinDirection == .downwards) {
                self.slotAtIndex -= 1
                
                if self.slotAtIndex <= 0 {
                    self.slotAtIndex = self.cardTextures.count - 1
                }
            } else {
                self.slotAtIndex += 1
                
                if self.slotAtIndex > self.cardTextures.count - 1 {
                    self.slotAtIndex = 0
                }
            }
            
            print("Slot:Completion with index: \(self.slotAtIndex)")
            completion()
        })

        var actionsVisible = [SKAction]()
        var actionsNext = [SKAction]()

        for _ in 1...count {
            actionsVisible.append(moveVisibleOut)
            actionsVisible.append(jumpVisibleFromOutToVisiblePos)

            actionsNext.append(moveHiddenToVisible)
            actionsNext.append(jumpHiddenFromVisibleToHiddenPos)
        }

        actionsNext.append(actionDone)

        self.visibleCard.run(SKAction.sequence(actionsVisible))
        self.hiddenCard.run(SKAction.sequence(actionsNext))
    }
}
