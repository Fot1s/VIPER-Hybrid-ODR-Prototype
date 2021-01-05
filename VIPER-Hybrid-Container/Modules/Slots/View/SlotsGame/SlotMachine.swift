//
//  SlotMachine.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 30/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotMachine {
    var cardTextures: [SKTexture]

    var slotColumnsArray: [SlotColumn]
    var slotColumnsRunning: [Bool]

    let numberOfColumns: Int
    let numberOfRows: Int
    let frame: CGRect
    let columnSpacing: CGFloat

    var resultIndexMatrix: [[Int]]

    let slotWidth: CGFloat
    var slotHeight: CGFloat

    let scene: SKScene

    var scoreCard: [Int]

    var isRunning: Bool {
        get {
            //if any slot is still running return true
            var varToReturn = false

            for slotRunning in slotColumnsRunning {
                varToReturn = varToReturn || slotRunning
            }

            return varToReturn
        }
        set(newValue) {
            for i in 0..<numberOfColumns {
                slotColumnsRunning[i] = newValue
            }
        }
    }

    init(scene: SKScene, frame: CGRect, numberOfColumns: Int, columnSpacing: CGFloat, numberOfRows: Int,
         slotsStartAtIndex: Int = 0, spinDirection: Slot.SpinDirection = .downwards ) {
        self.frame = frame
        self.numberOfColumns = numberOfColumns
        self.numberOfRows = numberOfRows
        self.columnSpacing = columnSpacing
        self.scene = scene

        self.resultIndexMatrix = Array(repeating: Array(), count: numberOfRows)

        var columnSpaces: CGFloat = 0

        cardTextures = [SKTexture]()
        for i in 0...8 {//inclusive is 9
            cardTextures.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
        }

        if numberOfColumns > 1 {
            columnSpaces = CGFloat(numberOfColumns-1) * columnSpacing
        }

        slotWidth = (self.frame.size.width - columnSpaces) / CGFloat(numberOfColumns)
        slotHeight = slotWidth / Constants.Slots.Game.cellGraphicRatioWidthToHeight

        if slotHeight * CGFloat(numberOfRows) > frame.size.height {
            print("fixed height")
            slotHeight = (frame.size.height - 32) / CGFloat(numberOfRows)
        }

        self.slotColumnsArray = [SlotColumn]()
        self.slotColumnsRunning = [Bool]()
        self.scoreCard = [Int]()

        for i in 0..<numberOfColumns {
            slotColumnsArray.append(
                SlotColumn(numberOfRows, cardTextures: cardTextures,
                           position: CGPoint(x: frame.origin.x + CGFloat(i) * (slotWidth+columnSpacing), y: frame.origin.y),
                           slotWidth: slotWidth, slotHeight: slotHeight, slotAtIndex: slotsStartAtIndex,
                           spinDirection: spinDirection, waitForTime: Double(i) * 0.25))
            slotColumnsRunning.append(false)

            if i == 0 {
                scoreCard.append(0)
            } else if i == 1 {
                scoreCard.append(100)
            } else {
                scoreCard.append(scoreCard[i-1] * 5)
            }
        }
    }

    func addCardsToScene(scene: SKScene) {
        for slotCol in self.slotColumnsArray {
            slotCol.addCardsToScene(scene)
        }

        let yourline2 = SKShapeNode()
        let pathToDraw2 = CGMutablePath()
        pathToDraw2.move(to: CGPoint(x: self.frame.minX, y: self.frame.origin.y))
        pathToDraw2.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.origin.y))
        yourline2.path = pathToDraw2
        yourline2.strokeColor = SKColor.red
        scene.addChild(yourline2)

        let yourline3 = SKShapeNode()
        let pathToDraw3 = CGMutablePath()
        pathToDraw3.move(to: CGPoint(x: self.frame.minX, y: frame.origin.y - frame.size.height))
        pathToDraw3.addLine(to: CGPoint(x: self.frame.maxX, y: frame.origin.y - frame.size.height))
        yourline3.path = pathToDraw3
        yourline3.strokeColor = SKColor.green
        scene.addChild(yourline3)

    }

    func spinNow(runForTimes: [UInt32], completion: @escaping(Int) -> Void) {
        isRunning = true

        for (index, slotColumn) in slotColumnsArray.enumerated() {
            slotColumn.spinWheel(runForTimes[index]) { resultIndices in

                self.slotColumnsRunning[index] = false
                self.resultIndexMatrix[index] = resultIndices

                if !self.isRunning {

                    var score: Int = 0

                    self.searchForWins(&score, &self.resultIndexMatrix)

                    print("Score: \(score)")

                    completion(score)
                }
            }
        }
    }

    func update(timeDelta: TimeInterval) {
        for slotColumn in slotColumnsArray {
            slotColumn.update(timeDelta: timeDelta)
        }

    }

    func searchForWins(_ score: inout Int, _ matrix: inout [[Int]]) {

        for columnIndex in stride(from: 0, to: matrix.count - 1, by: 1) {
            for rowIndex in 0..<matrix[columnIndex].count
                where matrix[columnIndex][rowIndex] != -1 {

//                if matrix[columnIndex][rowIndex] != -1 {
                    findWins(&score, columnIndex, rowIndex, &matrix, 0)
//                }
            }
        }
    }

    func findWins(_ score: inout Int, _ columnIndex: Int, _ rowIndex: Int, _ matrix: inout [[Int]], _ found: Int) {
        if columnIndex + 1 < matrix.count && matrix[columnIndex][rowIndex] == matrix[columnIndex+1][rowIndex] {
            findWins(&score, columnIndex+1, rowIndex, &matrix, found+1)
            matrix[columnIndex][rowIndex] = -1
        } else {
            if found > 0 {
//                print("Found! \(columnIndex) \(rowIndex) \(found)")

                addFoundRectangle(columnIndex, rowIndex, found)

                score += self.scoreCard[found]
            }
            matrix[columnIndex][rowIndex] = -1
        }
    }

    let fadeOut = SKAction.fadeOut(withDuration: 1.0)
    let removeFromParent = SKAction.removeFromParent()

    func addFoundRectangle(_ columnIndex: Int, _ rowIndex: Int, _ found: Int) {

        let startColumn = columnIndex - found

        //CGPoint(x:frame.origin.x + CGFloat(i) * (slotWidth+columnSpacing), y:frame.origin.y)

        let shapeNode = SKShapeNode(rect: CGRect(x: frame.origin.x + CGFloat(startColumn) * (slotWidth+columnSpacing),
                                                 y: frame.origin.y - CGFloat(numberOfRows - rowIndex) * slotHeight,
                                                 width: slotWidth * CGFloat(found + 1) + columnSpacing * CGFloat(found),
                                                 height: slotHeight))
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = UIColor.yellow
        shapeNode.lineWidth = 5
        scene.addChild(shapeNode)

        shapeNode.run(SKAction.sequence([fadeOut, removeFromParent]))
    }
}
