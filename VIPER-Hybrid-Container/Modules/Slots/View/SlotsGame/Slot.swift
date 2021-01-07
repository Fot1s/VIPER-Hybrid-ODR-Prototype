//
//  Slot.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 29/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class Slot {

    //A slot can rotate downwards or upwards
    enum SpinDirection {
        case downwards
        case upwards
    }

    var spinDirection: SpinDirection

    //the cards textures
    let cardTextures: [SKTexture]

    //the index of the currectly visible card
    var slotAtIndex: Int

    var visibleCard: SKSpriteNode
    var hiddenCard: SKSpriteNode

    //if the slot is currently running
    var slotRunning: Bool

    var position: CGPoint

    //slot size
    var slotWidth: CGFloat
    var slotHeight: CGFloat

    //card limits
    var hiddenPosY: CGFloat
    var visiblePosY: CGFloat
    var limitPosY: CGFloat

    init(position: CGPoint, cardTextures: [SKTexture], scene: SKScene,
         slotWidth: CGFloat, widthToHightRatio: CGFloat? = nil, slotAtIndex: Int = 0,
         spinDirection: SpinDirection = .downwards) {

        self.slotRunning = false

        self.cardTextures = cardTextures
        self.position = position
        self.slotWidth = slotWidth

        self.slotAtIndex = slotAtIndex
        self.spinDirection = spinDirection

        //if widthToHightRatio is set use it to calculate the height, else use the Constants value
        if let widthToHightRatio = widthToHightRatio {
            self.slotHeight = slotWidth / widthToHightRatio
        } else {
            self.slotHeight = slotWidth / Constants.Slots.Game.cellGraphicRatioWidthToHeight
        }

        self.visibleCard = SKSpriteNode(texture: cardTextures[slotAtIndex])

        self.visiblePosY = position.y - slotHeight/2

        self.visibleCard.position = CGPoint(x: position.x + slotWidth/2, y: visiblePosY)
        self.visibleCard.size = CGSize(width: slotWidth, height: slotHeight)

        //prepare the limits and cards depending on the spinDirection
        if self.spinDirection == .downwards {
            self.slotAtIndex += 1

            if self.slotAtIndex >= cardTextures.count {
                self.slotAtIndex = 0
            }

            self.hiddenCard = SKSpriteNode(texture: cardTextures[self.slotAtIndex])

            self.hiddenCard.position    = CGPoint(x: position.x + slotWidth/2, y: position.y + slotHeight/2)

            self.hiddenPosY = hiddenCard.position.y
            self.limitPosY = visibleCard.position.y - slotHeight

        } else {
            self.slotAtIndex -= 1

            if self.slotAtIndex <= 0 {
                self.slotAtIndex = cardTextures.count - 1
            }

            self.hiddenCard = SKSpriteNode(texture: cardTextures[self.slotAtIndex])

            self.hiddenCard.position    = CGPoint(x: position.x + slotWidth/2, y: position.y - slotHeight/2 - slotHeight)

            self.hiddenPosY = hiddenCard.position.y
            self.limitPosY = visibleCard.position.y + slotHeight
        }

        self.hiddenCard.size = CGSize(width: slotWidth, height: slotHeight)

        //create a mask
        let mask = SKSpriteNode(color: SKColor.black, size: CGSize(width: slotWidth, height: slotHeight))
        mask.position = CGPoint(x: position.x + slotWidth/2, y: position.y - slotHeight/2)

        //create a container, assign the mask and add the cards to it
        let container = SKCropNode()
        container.maskNode = mask

        container.addChild(visibleCard)
        container.addChild(hiddenCard)

        //add the container to the scene
        scene.addChild(container)
    }

    // Start spinning the Slot
    func spinWheel(_ count: Int, direction: Slot.SpinDirection, completion: @escaping() -> Void) {

        //Switch limit, hidden and visible positions on direction change after initialization
        if self.spinDirection != direction {
            let temp = hiddenPosY
            hiddenPosY = limitPosY
            limitPosY = temp

            hiddenCard.position.y = hiddenPosY

            var hiddenIndex: Int

            //while running the slotAtIndex is incremented to prepare for the next card
            //thats why we need to add or remove 2 places on direction change
            //the first resets to the visible card, th seconds point to the correct next card
            if direction == .downwards {
                self.slotAtIndex += 2

                if self.slotAtIndex >= cardTextures.count {
                    self.slotAtIndex -= cardTextures.count
                }

                hiddenIndex = self.slotAtIndex
            } else {
                self.slotAtIndex -= 2

                if self.slotAtIndex < 0 {
                    self.slotAtIndex = cardTextures.count + self.slotAtIndex
                }

                hiddenIndex = self.slotAtIndex
            }

            self.hiddenCard.texture = self.cardTextures[hiddenIndex]
            self.spinDirection = direction
        }

        //just a safety check
        guard !self.slotRunning else {
            print("Already running skip!")
            completion()
            return
        }

        //do not run if the count of runs given is 0 - we are already there
        guard count > 0 else {
            print("Will not start with a count of 0!")
            completion()
            return
        }

        //start running
        self.slotRunning = true

        let frameMidX = self.visibleCard.frame.midX

        // Action to move the visible card to the limit position in the specified duration
        let moveVisibleOut = SKAction.move(to: CGPoint(x: frameMidX, y: limitPosY),
                                           duration: TimeInterval(Constants.Slots.Game.timePerCreditNumber))

        // Action to move the hidden card to the visible position in the specified duration
        let moveHiddenToVisible = SKAction.move(to: CGPoint(x: frameMidX, y: visiblePosY),
                                                duration: TimeInterval(Constants.Slots.Game.timePerCreditNumber))

        // Action to reset the visible card to its initial position prior to the move and thus be ready for a new animation
        // It also (depending on direction) changes the hidden card texture to the next element to show
        let jumpVisibleFromOutToVisiblePos = SKAction.run({
            self.visibleCard.texture = self.hiddenCard.texture
            self.visibleCard.position.y = self.visiblePosY

            //depending on the direction inc/dec the index and assign the correct new texture
            if self.spinDirection == .downwards {
                self.slotAtIndex += 1

                if self.slotAtIndex > self.cardTextures.count - 1 {
                    self.slotAtIndex = 0
                }
                self.hiddenCard.texture = self.cardTextures[self.slotAtIndex]
            } else {
                self.slotAtIndex -= 1

                if self.slotAtIndex < 0 {
                    self.slotAtIndex = self.cardTextures.count - 1
                }
                self.hiddenCard.texture = self.cardTextures[self.slotAtIndex]
            }
        })

        //Action to reset the position of the hidden card
        let jumpHiddenFromVisibleToHiddenPos = SKAction.run({
            self.hiddenCard.position.y = self.hiddenPosY
        })

        // Action to run when the cards finished animating/spinning
        let actionDone = SKAction.run({
            self.slotRunning = false

            completion()
        })

        //prepare the cards actions here
        var actionsVisible = [SKAction]()
        var actionsNext = [SKAction]()

        //for every spin add the appropriate actions:
        //visible moves out and on end jumps to initial position
        //hidden moves to visible and then to initial position
        for _ in 1...count {
            actionsVisible.append(moveVisibleOut)
            actionsVisible.append(jumpVisibleFromOutToVisiblePos)

            actionsNext.append(moveHiddenToVisible)
            actionsNext.append(jumpHiddenFromVisibleToHiddenPos)
        }

        //add a last actionDone
        actionsNext.append(actionDone)

        //and run them
        self.visibleCard.run(SKAction.sequence(actionsVisible))
        self.hiddenCard.run(SKAction.sequence(actionsNext))
    }
}
