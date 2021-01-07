//
//  SlotMachine.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 29/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotRow {

    //the cards textures
    var cardTextures: [SKTexture]

    //the number of slots in the row
    let numberOfSlots: Int

    //an array keeping all slots in the row
    var slotsArray: [Slot]

    //which of them are currently running
    var slotsRunning: [Bool]

    //TODO:
    var lastNumberShown: Int

    let frame: CGRect
    let columnSpacing: CGFloat
    let slotWidth: CGFloat

    //A computed property that returns true if any Slot in the row is still running
    //on set it sets all individual slots as running
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

    init(frame: CGRect, textures: [SKTexture], scene: SKScene,
         numberOfSlots: Int, columnSpacing: CGFloat, widthToHightRatio: CGFloat? = nil,
         initialNumber: Int = 0, spinDirection: Slot.SpinDirection = .downwards ) {
        self.frame = frame
        self.numberOfSlots = numberOfSlots
        self.columnSpacing = columnSpacing
        self.cardTextures = textures
        self.lastNumberShown = initialNumber

        var columnSpaces: CGFloat = 0

        //calculate how much space is needed between slots
        if numberOfSlots > 1 {
            columnSpaces = CGFloat(numberOfSlots-1) * columnSpacing
        }

        //find the actual slot width - it depends on the row frame
        slotWidth = (self.frame.size.width - columnSpaces) / CGFloat(numberOfSlots)

        slotsArray = [Slot]()
        slotsRunning = [Bool]()

        //get the digits of the initialNumber to show
        let scoreDigits = String(format: "%0\(numberOfSlots)d", initialNumber).digits

        //Add the slots to the array, and initialize the slotsRunning array with false for each slot
        for i in 0..<numberOfSlots {
            slotsArray.append(Slot(position: CGPoint(x: frame.origin.x + CGFloat(i) * (slotWidth+columnSpacing), y: frame.origin.y),
                                   cardTextures: cardTextures, scene: scene,
                                   slotWidth: slotWidth, widthToHightRatio: widthToHightRatio, slotAtIndex: scoreDigits[i],
                                   spinDirection: spinDirection))
            slotsRunning.append(false)
        }
    }

    // Start spining to the specified inNumber
    func spinTo(_ inNumber: Int, completion: @escaping() -> Void) {

        let spinDirection: Slot.SpinDirection

        var number = inNumber

        //we speen down when adding and up when subtracting
        if inNumber > lastNumberShown {
            spinDirection = Slot.SpinDirection.downwards
        } else {
            spinDirection = Slot.SpinDirection.upwards
        }

        //make sure the number is positive
        number = abs(number)

        let scoreDigits = String(format: "%0\(numberOfSlots)d", number).digits
        var previousDigits = String(format: "%0\(numberOfSlots)d", lastNumberShown).digits

        //find the difference in indexes between the last shown number and the new number
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

        //save the new number and call spinNow to spin to the correct number using the calculated differences and spinDirection
        lastNumberShown = number
        spinNow(runForTimes: previousDigits, direction: spinDirection, completion: completion)
    }

    //spin every slot for the specified ammount of times and when done call complete
    func spinNow(runForTimes: [Int], direction: Slot.SpinDirection, completion: @escaping() -> Void) {

        //the row is now running (all slots set to true)
        isRunning = true

        for (index, slot) in slotsArray.enumerated() {

            //for every slot call its spin method
            slot.spinWheel(Int(runForTimes[index]), direction: direction) {

                //on completion mark slot as done
                self.slotsRunning[index] = false

                //if all slots are done call complete on the row
                if !self.isRunning {
                    completion()
                }
            }
        }
    }
}
