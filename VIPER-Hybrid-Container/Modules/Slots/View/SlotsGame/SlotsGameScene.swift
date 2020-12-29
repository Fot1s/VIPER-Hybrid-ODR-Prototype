//
//  SlotsGameScene.swift
//  VIPER-Hybrid-Container
//
//  Created by Demitri Delinikolas on 28/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class Slot {

    var sloatAtIndex = 2
    
    var visibleCard:SKSpriteNode!
    var nextCard:SKSpriteNode!
    var visibleCard2:SKSpriteNode!
    var nextCard2:SKSpriteNode!
    var visibleCard3:SKSpriteNode!
    var nextCard3:SKSpriteNode!

    var slotRunning = false

    func setCards(visibleCard:SKSpriteNode, nextCard:SKSpriteNode) {
        self.visibleCard = visibleCard
        self.nextCard = nextCard
    }
    
    func spinWheel(_ count:UInt32, allCardTextures:[SKTexture],  completion: @escaping() -> Void) {
        
        guard count > 0 else {
            print("Will not start with a count of 0!");
            return
        }
        
        self.slotRunning = true

        // Determine speed of the monster
        let actualDuration = 0.05//arc4random_uniform(2) + 2 //(2->4)
        
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
            
            self.nextCard.texture = allCardTextures[self.sloatAtIndex]
            self.sloatAtIndex += 1
            
            if self.sloatAtIndex > allCardTextures.count - 1 {
                self.sloatAtIndex = 0
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
        
        //        let runOneRound = SKAction.run({
        //            self.visibleCard?.run(SKAction.sequence([moveVisibleToBottom, jumpVisibleToTop]))
        //            self.nextCard?.run(SKAction.sequence([moveNextToVisible,jumpNextToTop]))
        //            print("round run!")
        //        })
        //
        //        self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([runOneRound,waitAction]), count: count),actionDone]))
        //
        
    }
}

class SlotsGameScene: SKScene {
    
    var slotsRunning = false
    
    var visibleCard: SKSpriteNode?
    var nextCard: SKSpriteNode?
    var visibleCard2: SKSpriteNode?
    var nextCard2: SKSpriteNode?
    var visibleCard3: SKSpriteNode?
    var nextCard3: SKSpriteNode?

    var originalPos:CGPoint?
    
    var allCardTextures:[SKTexture]?
    
    let numberOfSlots = 3
    
    var slotsArray:[Slot]?
    

    //game init
    override func didMove(to view: SKView) {
        
        //load all card textures
        //TODO: Direct texture grab?
        allCardTextures = [SKTexture]()
        for i in 0...8 {//inclusive is 9
            allCardTextures!.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
        }
        
        let card1 = SKSpriteNode(texture: allCardTextures![0])
        let card2 = SKSpriteNode(texture: allCardTextures![1])
        let card3 = SKSpriteNode(texture: allCardTextures![0])
        let card4 = SKSpriteNode(texture: allCardTextures![1])
        let card5 = SKSpriteNode(texture: allCardTextures![0])
        let card6 = SKSpriteNode(texture: allCardTextures![1])

        
        let aspectRatio = card1.size.width/card1.size.height
        
        card1.size = CGSize(width: self.frame.size.width/3, height: self.frame.size.width/3/aspectRatio)
        card2.size = card1.size
        card3.size = card1.size
        card4.size = card1.size
        card5.size = card1.size
        card6.size = card1.size

        card1.position = CGPoint(x:self.frame.minX + card1.frame.width/2,y:self.frame.maxY - card1.frame.height/2-40)
        card2.position = CGPoint(x:self.frame.minX + card1.frame.width/2,y:self.frame.maxY - card1.frame.height/2-40 + card1.frame.height)
        
        card3.position = CGPoint(x:self.frame.minX + card1.frame.width + card1.frame.width/2,y:self.frame.maxY - card1.frame.height/2-40)
        card4.position = CGPoint(x:self.frame.minX + card1.frame.width/2,y:self.frame.maxY - card1.frame.height/2-40 + card1.frame.height)

        card5.position = CGPoint(x:self.frame.minX + 2*card1.frame.width + card1.frame.width/2,y:self.frame.maxY - card1.frame.height/2-40)
        card6.position = CGPoint(x:self.frame.minX + 2*card1.frame.width/2,y:self.frame.maxY - card1.frame.height/2-40 + card1.frame.height)

        let mask = SKSpriteNode(color: SKColor.black, size: CGSize(width: 3*card1.frame.width, height: card1.frame.height))
        mask.position = CGPoint(x:self.frame.minX + mask.frame.width/2,y:self.frame.maxY - card1.frame.height/2-40)
        
        let container = SKCropNode()
//        container.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        container.maskNode = mask

        container.addChild(card1)
        container.addChild(card2)
        container.addChild(card3)
        container.addChild(card4)
        container.addChild(card5)
        container.addChild(card6)

        self.addChild(container)
        
        self.visibleCard = card1 ;
        self.nextCard = card2 ;
        self.visibleCard2 = card3 ;
        self.nextCard2 = card4 ;
        self.visibleCard3 = card5 ;
        self.nextCard3 = card6 ;

        self.originalPos = self.visibleCard?.position
        
        self.slot1 = Slot()
        self.slot1?.setCards(visibleCard: self.visibleCard!, nextCard: self.nextCard!)
        self.slot2 = Slot()
        self.slot2?.setCards(visibleCard: self.visibleCard2!, nextCard: self.nextCard2!)
        self.slot3 = Slot()
        self.slot3?.setCards(visibleCard: self.visibleCard3!, nextCard: self.nextCard3!)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!slotsRunning) {
            slotsRunning = true
            print("Slots running")
            startGame()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    var slot1:Slot?
    
    var slot2:Slot?
    
    var slot3:Slot?

    func startGame() {
        

        let spinWheel = SKAction.run({
            self.slot1?.spinWheel(30 + arc4random_uniform(50), allCardTextures: self.allCardTextures!){
                self.slotsRunning = false
                print("Slots Stopped running!")
            }
            self.slot2?.spinWheel(30 + arc4random_uniform(50), allCardTextures: self.allCardTextures!){
                self.slotsRunning = false
                print("Slots Stopped running!")
            }
            self.slot3?.spinWheel(30 + arc4random_uniform(50), allCardTextures: self.allCardTextures!){
                self.slotsRunning = false
                print("Slots Stopped running!")
            }
        })
        
        run(SKAction.sequence([spinWheel]))
    }
    
    

}
