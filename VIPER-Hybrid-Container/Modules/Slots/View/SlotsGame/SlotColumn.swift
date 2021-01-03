//
//  Slot.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 29/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotColumn {
    let cardTextures:[SKTexture]
    let position:CGPoint
    let slotWidth:CGFloat
    let slotHeight:CGFloat
    let numSlots:Int
    
    var cardIndices:[Int]
    
    var cards:[SKSpriteNode]
    var slotAtIndex:Int
    
    
    var slotRunning:Bool
    var cardsAdded:Bool

    let topPosY:CGFloat
    let bottomPosY:CGFloat
    
    let spinDirection: Slot.SpinDirection
    
    var rollFor:UInt32 = 0

    init(_ numSlots:Int, cardTextures:[SKTexture], position:CGPoint, slotWidth:CGFloat, slotHeight:CGFloat, slotAtIndex:Int = 0, spinDirection:Slot.SpinDirection = .downwards ) {
        self.numSlots = numSlots
        self.cardTextures = cardTextures
        self.position = position
        self.slotWidth = slotWidth
        self.slotHeight = slotHeight
        self.slotAtIndex = slotAtIndex
        self.spinDirection = spinDirection
        
        self.slotRunning = false ;
        self.cardsAdded = false ;
        
        self.topPosY = position.y + slotHeight/2
        self.bottomPosY = position.y - CGFloat(numSlots) * slotHeight - slotHeight/2
        
        self.cards = [SKSpriteNode]()
        self.cardIndices = [Int]()
        initCards()
    }
    
    func initCards() {
        var card:SKSpriteNode
        
        var upWardsFixMinus1 = 0
        
        //we need numSlots + 1 cards ie: 0 to numSlots inclusive
        for i in 0...numSlots {
            
            if (i == 0 && spinDirection == .upwards) {
                slotAtIndex -= 1
                
                if (slotAtIndex < 0) {
                    slotAtIndex = cardTextures.count - 1
                }
                
                upWardsFixMinus1 = -1
            }
            
            cardIndices.append(slotAtIndex)
            
            card = SKSpriteNode(texture: cardTextures[slotAtIndex])
            card.size = CGSize(width: slotWidth, height: slotHeight)
            
            card.position = CGPoint(x:position.x + slotWidth/2 ,y: bottomPosY + CGFloat(i + 1 + upWardsFixMinus1)*slotHeight)
            
            cards.append(card)
            
            slotAtIndex += 1
            
            if (slotAtIndex >= cardTextures.count) {
                slotAtIndex = 0
            }
        }
        
        //reset the slot index if we are moving upwards
        if (spinDirection == .upwards) {
            slotAtIndex -= (numSlots + 2)  //num slots goes back to initial, -1 for hidden, -1 for next
            
            if (slotAtIndex < 0) {
                
                //adding the negative index to count arrives at the now correct index
                slotAtIndex  = cardTextures.count + slotAtIndex
            }
        }
        
        print("Cards inited: \(cardIndices) with Next \(slotAtIndex)") ;
    }
    
    
    func addCardsToScene(_ scene: SKScene) {
        
        let mask = SKSpriteNode(color: SKColor.black, size: CGSize(width: slotWidth, height: slotHeight*CGFloat(numSlots)))
        mask.position = CGPoint(x:position.x + slotWidth/2 ,y: position.y - mask.size.height/2)

        let container = SKCropNode()
        container.maskNode = mask

        for card in cards {
            container.addChild(card)
        }
        
        scene.addChild(container)
        self.cardsAdded = true
    }
    
    let timeToMoveOneCard:CGFloat = 1.5 //second  // ie in timetomove sec height pixels
    
    func update(timeDelta:TimeInterval) {
        
        if slotRunning {
 
            for card in cards {
                
                if (spinDirection == .downwards) {
                    card.position.y -= slotHeight * CGFloat(timeDelta) / timeToMoveOneCard
                    
                    if card.position.y < bottomPosY {
                        
                        print("Down with Diff: \(bottomPosY-card.position.y)")
                        
                        rollFor -= 1
                        
                        if (rollFor == 0) {
                            card.position.y = topPosY
                        } else {
                            card.position.y = topPosY - (bottomPosY-card.position.y)// add the difference to the top to avoid gaps
                        }
                        
                        cardIndices.remove(at: 0)
                        cardIndices.append(slotAtIndex)
                        
                        card.texture = cardTextures[slotAtIndex]
                        
                        slotAtIndex += 1
                        if (slotAtIndex >= cardTextures.count) {
                            slotAtIndex = 0
                        }
                        
                        
                        print("Rolls Left: \(rollFor)")
                    }
                } else {
                    card.position.y += slotHeight * CGFloat(timeDelta) / timeToMoveOneCard
                    
                    if card.position.y > position.y + slotHeight / 2 {
                        
                        print("Upp with Diff: \(card.position.y - (position.y + slotHeight / 2))")

                        rollFor -= 1
                        
                        if (rollFor == 0) {
                            card.position.y = position.y - CGFloat(numSlots) * slotHeight - slotHeight/2
                        } else {
                            card.position.y = position.y - CGFloat(numSlots) * slotHeight - slotHeight/2 + (card.position.y - (position.y + slotHeight / 2))// add the difference to the top to avoid gaps
                        }
                        
                        _ = cardIndices.popLast()
                        cardIndices.insert(slotAtIndex, at: 0)
                        
                        card.texture = cardTextures[slotAtIndex]
                        
                        slotAtIndex -= 1
                        if (slotAtIndex < 0) {
                            slotAtIndex = cardTextures.count - 1
                        }
                        
                        
                        print("Rolls Left: \(rollFor)")
                    }

                }
            }
            
            if rollFor == 0 {
                slotRunning = false
                
                if let handler = completionHandler {
                    handler()
                }
                
                if (spinDirection == .downwards) {
                    print("Cards ended: \(cardIndices[0...cardIndices.count-2])") ;
                } else {
                    print("Cards ended: \(cardIndices[1...cardIndices.count-1])") ;
                }

            }
        }
    }
    
    var completionHandler: (() -> Void)?
    
    func spinWheel(_ count:UInt32, completion: @escaping() -> Void) {
        
        guard self.cardsAdded else {
            print("Cards must be added to the scene before spinning!");
            return
        }

        guard count > 0 else {
            print("Will not start with a count of 0!");
            return
        }
        
        self.rollFor = count
        self.slotRunning = true
        self.completionHandler = completion
    }
}


