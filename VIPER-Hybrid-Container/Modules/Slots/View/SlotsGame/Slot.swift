//
//  Slot.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 29/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class Slot {
    let cardTextures:[SKTexture]

    var slotAtIndex:Int
    
    var visibleCard:SKSpriteNode!
    var nextCard:SKSpriteNode!
    
    var slotRunning = false
    var cardsAdded = false
    
    var position:CGPoint
    var slotWidth:CGFloat
    
    var topPosY = CGFloat(0)
    var bottomPosY = CGFloat(0)

    init(_ cardTextures:[SKTexture], position:CGPoint, slotWidth:CGFloat, slotAtIndex:Int = 0) {
        self.cardTextures = cardTextures
        self.position = position
        self.slotWidth = slotWidth
        self.slotAtIndex = slotAtIndex
    }
    
    func remCardsFromScene() {
        visibleCard?.parent?.removeFromParent()
    }
    
    func addCardsToScene(_ scene: SKScene) {
        
        visibleCard = SKSpriteNode(texture: cardTextures[slotAtIndex])
        nextCard = SKSpriteNode(texture: cardTextures[slotAtIndex+1])
        
        slotAtIndex += 2

        let aspectRatio = visibleCard.size.width/visibleCard.size.height
        print("Aspect: \(aspectRatio)") ;
        
        visibleCard.size = CGSize(width: slotWidth, height: slotWidth/aspectRatio)
        nextCard.size = visibleCard.size

        visibleCard.position = CGPoint(x:position.x + visibleCard.size.width/2 ,y: position.y - visibleCard.size.height/2)
        nextCard.position    = CGPoint(x:position.x + visibleCard.size.width/2 ,y: position.y - visibleCard.size.height/2 + nextCard.size.height)
        
        topPosY = nextCard.position.y
        bottomPosY = visibleCard.position.y - visibleCard.size.height
        
        let mask = SKSpriteNode(color: SKColor.black, size: CGSize(width: visibleCard.frame.width, height: visibleCard.frame.height))
        mask.position = CGPoint(x:position.x + visibleCard.size.width/2 ,y: position.y - visibleCard.size.height/2)

        let container = SKCropNode()
        container.maskNode = mask

        container.addChild(visibleCard)
        container.addChild(nextCard)
        
        scene.addChild(container)

        self.cardsAdded = true
    }
    
//    func update(timeDelta:TimeInterval) {
//        self.visibleCard.position = CGPoint(x:self.visibleCard.position.x,y:self.visibleCard.position.y - 1)
//        self.nextCard.position = CGPoint(x:self.nextCard.position.x,y:self.nextCard.position.y - 1)
//        
//        if (visibleCard.position.y < bottomPosY) {
//            visibleCard.position.y = topPosY
//            self.visibleCard.position = CGPoint(x:self.visibleCard.position.x,y:self.visibleCard.position.y)
//        }
//        
//        if (nextCard.position.y < bottomPosY) {
//            nextCard.position.y = topPosY
//            self.nextCard.position = CGPoint(x:self.nextCard.position.x,y:self.nextCard.position.y)
//        }
//    }
    
    func spinWheel(_ count:UInt32, allCardTextures:[SKTexture],  completion: @escaping() -> Void) {
        
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
        let actualDuration = 1 //2.0 / 25 //arc4random_uniform(2) + 2 //(2->4)

        let frameMidX = self.visibleCard.frame.midX
        let visibleY = self.visibleCard.frame.origin.y - self.visibleCard.frame.size.height/2
        let nextY = (self.nextCard.frame.origin.y) - self.nextCard.frame.size.height/2

        // Create the actions
        let moveVisibleToBottom = SKAction.move(to: CGPoint(x: frameMidX, y: visibleY), duration: TimeInterval(actualDuration))

        let moveNextToVisible = SKAction.move(to: CGPoint(x: frameMidX, y: nextY),
                                              duration: TimeInterval(actualDuration))


        let jumpVisibleToTop = SKAction.run({
            self.visibleCard.texture = self.nextCard.texture
            self.visibleCard.position.y = self.visibleCard.position.y + self.visibleCard.size.height

            self.nextCard.texture = allCardTextures[self.slotAtIndex]
            self.slotAtIndex += 1

            if self.slotAtIndex > allCardTextures.count - 1 {
                self.slotAtIndex = 0
            }
        })

        let jumpNextToTop = SKAction.run({
            self.nextCard.position.y = self.nextCard.position.y + self.nextCard.size.height
        })



        let actionDone = SKAction.run({
            self.slotRunning = false
            print("action done!")
            completion()
        })

        //        let waitAction = SKAction.wait(forDuration: TimeInterval(actualDuration))

        var actionsVisible = [SKAction]()
        var actionsNext = [SKAction]()

        for _ in 1...count {
            actionsVisible.append(moveVisibleToBottom)
            actionsVisible.append(jumpVisibleToTop)

            actionsNext.append(moveNextToVisible)
            actionsNext.append(jumpNextToTop)
        }

        actionsNext.append(actionDone)

        self.visibleCard.run(SKAction.sequence(actionsVisible))
        self.nextCard.run(SKAction.sequence(actionsNext))
    }
}
