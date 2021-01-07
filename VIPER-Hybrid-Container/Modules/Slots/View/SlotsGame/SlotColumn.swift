//
//  Slot.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 29/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotColumn {

    //the column textures
    let cardTextures: [SKTexture]

    //position of the column and number of slots
    let position: CGPoint
    let numSlots: Int

    //slot width and height
    let slotWidth: CGFloat
    let slotHeight: CGFloat

    //the index of every card in the column
    var cardIndices: [Int]

    var cards: [SKSpriteNode]

    //used to track the current/next card switches
    var slotAtIndex: Int

    //is the column currently running
    var isRunning: Bool

    //limits
    let topPosY: CGFloat
    let bottomPosY: CGFloat

    let spinDirection: Slot.SpinDirection

    //how many times to roll
    var rollFor: Int = 0

    //how long the game has run after start was called on this column
    //used in conjuction with waitForTime bellow to start the column after some wait time
    var runForTime: TimeInterval = 0

    //the time to wait before starting the column
    var waitForTime: CFTimeInterval

    init(position: CGPoint, cardTextures: [SKTexture], scene: SKScene, numSlots: Int, slotWidth: CGFloat, slotHeight: CGFloat,
         slotAtIndex: Int = 0, spinDirection: Slot.SpinDirection = .downwards, waitForTime: CFTimeInterval) {
        self.numSlots = numSlots
        self.cardTextures = cardTextures
        self.position = position
        self.slotWidth = slotWidth
        self.slotHeight = slotHeight
        self.slotAtIndex = slotAtIndex
        self.spinDirection = spinDirection
        self.waitForTime = waitForTime

        self.isRunning = false

        self.topPosY = position.y + slotHeight/2
        self.bottomPosY = position.y - CGFloat(numSlots) * slotHeight - slotHeight/2

        self.cards = [SKSpriteNode]()
        self.cardIndices = [Int]()

        initCards(scene: scene)
    }

    func initCards(scene: SKScene) {
        var card: SKSpriteNode

        //when going upwards we decrement one so the first card will be hidden
        var upWardsFixMinus1 = 0

        //we need numSlots + 1 cards ie: 0 to numSlots inclusive
        for i in 0...numSlots {

            if i == 0 && spinDirection == .upwards {
                slotAtIndex -= 1

                if slotAtIndex < 0 {
                    slotAtIndex = cardTextures.count - 1
                }

                upWardsFixMinus1 = -1
            }

            cardIndices.append(slotAtIndex)

            card = SKSpriteNode(texture: cardTextures[slotAtIndex])
            card.size = CGSize(width: slotWidth, height: slotHeight)

            card.position = CGPoint(x: position.x + slotWidth/2, y: bottomPosY + CGFloat(i + 1 + upWardsFixMinus1)*slotHeight)

            cards.append(card)

            slotAtIndex += 1

            if slotAtIndex >= cardTextures.count {
                slotAtIndex = 0
            }
        }

        //if we are moving upwards we need to reset the slot index to the next visible card
        if spinDirection == .upwards {
            slotAtIndex -= (numSlots + 2)  //num slots goes back to initial, -1 for hidden, -1 for next

            if slotAtIndex < 0 {

                //adding the negative index to count arrives at the now correct index
                slotAtIndex  = cardTextures.count + slotAtIndex
            }
        }

        let mask = SKSpriteNode(color: SKColor.black, size: CGSize(width: slotWidth, height: slotHeight*CGFloat(numSlots)))
        mask.position = CGPoint(x: position.x + slotWidth/2, y: position.y - mask.size.height/2)

        let container = SKCropNode()
        container.maskNode = mask

        for card in cards {
            container.addChild(card)
        }

        scene.addChild(container)
    }

    func update(timeDelta: TimeInterval) {

        //skip updates if column is not running
        if !isRunning {
            return
        }

        runForTime += timeDelta

        //skip updates if the wait time has not passed yet
        if runForTime <= waitForTime {
            return
        }

        //update card positions decrement rollFor when a card is switched
        updateCardPositions(timeDelta: timeDelta)

        //when done
        if rollFor <= 0 {

            //as in init a small fix depending on direction
            var indexChange = 0
            if spinDirection == .downwards {
                indexChange = 1
            }

            //we just finished, move all cards to their 'correct' positions, removing any trailing space due to timing
            //for more info check bellow in updateCardPositions
            for (index, card) in cards.enumerated() {
                card.position = CGPoint(x: position.x + slotWidth/2, y: bottomPosY + CGFloat(index + indexChange)*slotHeight)
            }

            //stops the updates from being handled
            isRunning = false

            //we are done return the resulting indices to the parent
            if let handler = completionHandler {
                callTheCompletionHandler(handler)
            }
        }
    }

    //calls the completion handler closure with the correct results based on spin direction
    func callTheCompletionHandler(_ handler: ([Int]) -> Void) {

        //depending on direction return the correct/visible card indices
        if spinDirection == .downwards {

            //last card is the hidden one here
            handler(Array(cardIndices[0...cardIndices.count-2]))
        } else {

            //first card is hidden one here
            handler(Array(cardIndices[1...cardIndices.count-1]))
        }
    }

    //updates the card positions and decrements the rollFor variable
    func updateCardPositions(timeDelta: TimeInterval) {

        //for every card in the column
        for card in cards {

            if spinDirection == .downwards {

                //move the card downwards
                card.position.y -= slotHeight * CGFloat(timeDelta) / Constants.Slots.Game.timePerCard

                //if outside the bottom limit
                if card.position.y < bottomPosY {

                    //decrement the roll count
                    rollFor -= 1

                    //move the card to its proper place, adding the overshoot amount of movement to avoid gaps
                    card.position.y = topPosY - (bottomPosY-card.position.y)

                    //roll the indices, remove the first and add the next card index to the end (we are moving downwards)
                    cardIndices.remove(at: 0)
                    cardIndices.append(slotAtIndex)

                    //roll the cards
                    cards.append(cards.remove(at: 0))

                    card.texture = cardTextures[slotAtIndex]

                    slotAtIndex += 1
                    if slotAtIndex >= cardTextures.count {
                        slotAtIndex = 0
                    }
                }
            } else {

                //move the card upwards
                card.position.y += slotHeight * CGFloat(timeDelta) / Constants.Slots.Game.timePerCard

                //if outside the top limit
                if card.position.y > position.y + slotHeight / 2 {

                    //decrement the roll count
                    rollFor -= 1

                    //move the card to its proper place, adding the overshoot amount of movement to avoid gaps
                    card.position.y = position.y - CGFloat(numSlots) * slotHeight - slotHeight/2 +
                                      (card.position.y - (position.y + slotHeight / 2))

                    //roll the indices, remove the last and add the next card index to the front (we are moving upwards)
                    _ = cardIndices.popLast()
                    cardIndices.insert(slotAtIndex, at: 0)

                    //roll the cards
                    cards.insert(cards.popLast()!, at: 0)

                    card.texture = cardTextures[slotAtIndex]

                    slotAtIndex -= 1
                    if slotAtIndex < 0 {
                        slotAtIndex = cardTextures.count - 1
                    }
                }
            }
        }
    }

    //we save the completion passed at spinWheel bellow in order to call it from update when the column ends running
    var completionHandler: (([Int]) -> Void)?

    //called to start the column spinning
    func spinWheel(_ count: UInt32, completion: @escaping([Int]) -> Void) {

        //do not spin if the count is 0, just call the completion handler as we are already done and return
        guard count > 0 else {

            callTheCompletionHandler(completion)
            return
        }

        self.rollFor = Int(count)
        self.runForTime = 0
        self.isRunning = true
        self.completionHandler = completion
    }
}
