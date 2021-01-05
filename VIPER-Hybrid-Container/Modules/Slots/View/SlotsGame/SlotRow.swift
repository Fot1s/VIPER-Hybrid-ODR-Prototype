//
//  SlotMachine.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 29/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotRow {
    var cardTextures: [SKTexture]

    var slotsArray: [Slot]
    var slotsRunning: [Bool]
    var lastNumber: Int
//    var spinDirection: Slot.SpinDirection

    let numberOfSlots: Int
    let frame: CGRect
    let columnSpacing: CGFloat
    let slotWidth: CGFloat
//    let slotsStartAtIndex:Int

    var isRunning: Bool {
        get {
            //if any slot is still running return true
            var varToReturn = false

            for slotRunning in slotsRunning {
                varToReturn = varToReturn || slotRunning
            }

            return varToReturn
        }
        set(newValue) {
            for i in 0..<numberOfSlots {
                slotsRunning[i] = newValue
            }
        }
    }

    init(frame: CGRect, textures: [SKTexture], numberOfSlots: Int, columnSpacing: CGFloat,
         initialNumber: Int = 0, spinDirection: Slot.SpinDirection = .downwards ) {
        self.frame = frame
        self.numberOfSlots = numberOfSlots
        self.columnSpacing = columnSpacing
        self.cardTextures = textures
        self.lastNumber = initialNumber

        var columnSpaces: CGFloat = 0

        if numberOfSlots > 1 {
            columnSpaces = CGFloat(numberOfSlots-1) * columnSpacing
        }

        slotWidth = (self.frame.size.width - columnSpaces) / CGFloat(numberOfSlots)

        slotsArray = [Slot]()
        slotsRunning = [Bool]()

        let scoreDigits = String(format: "%0\(numberOfSlots)d", initialNumber).digits

        for i in 0..<numberOfSlots {
            slotsArray.append(Slot(cardTextures,
                                   position: CGPoint(x: frame.origin.x + CGFloat(i) * (slotWidth+columnSpacing), y: frame.origin.y),
                                   slotWidth: slotWidth, slotAtIndex: scoreDigits[i], spinDirection: spinDirection))
            slotsRunning.append(false)
        }
    }

    func addCardsToScene(scene: SKScene) {

        for slot in slotsArray {
            slot.addCardsToScene(scene)
        }
    }

    func remCardsFromScene() {

        for slot in slotsArray {
            slot.remCardsFromScene()
        }
    }

    func spinTo(_ inNumber: Int, completion: @escaping() -> Void) {

        let spinDirection: Slot.SpinDirection

        var number = inNumber

        if inNumber > lastNumber {
            spinDirection = Slot.SpinDirection.downwards
        } else {
            spinDirection = Slot.SpinDirection.upwards

        }

        //convert to positive
        number = abs(number)

        let scoreDigits = String(format: "%0\(numberOfSlots)d", number).digits
        var previousDigits = String(format: "%0\(numberOfSlots)d", lastNumber).digits

        for i in previousDigits.indices {

            let diff = scoreDigits[i] - previousDigits[i]

            if spinDirection == Slot.SpinDirection.downwards {
                if diff >= 0 {
                    previousDigits[i] = diff

                    if previousDigits[i] >= 10 {
                        previousDigits[i] -= 10
                    }
                } else {
                    previousDigits[i] = 10 + diff
                }
            } else {
                if diff >= 0 {
                    previousDigits[i] = 10 - diff

                    if previousDigits[i] >= 10 {
                        previousDigits[i] -= 10
                    }
                } else {
                    previousDigits[i] = -diff
                }
            }
        }

        lastNumber = number
        spinNow(runForTimes: previousDigits, direction: spinDirection, completion: completion)
    }

    func spinNow(runForTimes: [Int], direction: Slot.SpinDirection, completion: @escaping() -> Void) {
        isRunning = true

        for (index, slot) in slotsArray.enumerated() {
            slot.spinWheel(Int(runForTimes[index]), direction: direction) {
                self.slotsRunning[index] = false

                if !self.isRunning {
                    completion()
                }
            }
        }
    }
}
