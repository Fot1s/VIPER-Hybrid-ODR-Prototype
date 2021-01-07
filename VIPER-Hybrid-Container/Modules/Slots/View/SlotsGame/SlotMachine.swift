//
//  SlotMachine.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 30/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import SpriteKit

class SlotMachine {
    //the card textures to use
    var cardTextures: [SKTexture]

    let frame: CGRect

    //number of columns, rows and the spacing between columns for the SlotMachine
    let numberOfColumns: Int
    let numberOfRows: Int
    let columnSpacing: CGFloat

    //keep all slotColumns here
    var slotColumnsArray: [SlotColumn]

    //which column is running
    var slotColumnsRunning: [Bool]

    //a matrix of all column result indices
    var resultIndexMatrix: [[Int]]

    //slot width and height
    let slotWidth: CGFloat
    var slotHeight: CGFloat

    //the sprite kit scene we will addd our sprites to
    let scene: SKScene

    //keeps the value of each win,
    //as we are loooking for pairs, triples, quads and so on every index has an associated score
    //0   points for a single cell
    //100 points for a pair
    //previous*5 for the next wins ie: 500 for a triple, 2500 for a quad, 12500 for 5 in a row, ++
    var scoreBoard: [Int]

    //A computed property that returns true if any Column in the slotColumnsArray is still running
    //on set it sets all individual columns as running

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

    init(frame: CGRect, scene: SKScene, numberOfColumns: Int, columnSpacing: CGFloat, numberOfRows: Int,
         slotsStartAtIndex: Int = 0, spinDirection: Slot.SpinDirection = .downwards ) {
        self.frame = frame
        self.numberOfColumns = numberOfColumns
        self.numberOfRows = numberOfRows
        self.columnSpacing = columnSpacing
        self.scene = scene

        //initialize the resultIndexMatrix
        self.resultIndexMatrix = Array(repeating: Array(), count: numberOfColumns)

        //load the card textures
        cardTextures = [SKTexture]()
        for i in 0...8 {//inclusive is 9
            cardTextures.append(SKSpriteNode(imageNamed: "card\(i+1)").texture!)
        }

        var columnSpaces: CGFloat = 0

        //calculate how much space is needed between columns
        if numberOfColumns > 1 {
            columnSpaces = CGFloat(numberOfColumns-1) * columnSpacing
        }

        //calculate slotWidth depending on the frame width and the numberOfColumns
        slotWidth = (self.frame.size.width - columnSpaces) / CGFloat(numberOfColumns)

        //calculate the slotHeight
        slotHeight = slotWidth / Constants.Slots.Game.cellGraphicRatioWidthToHeight

        //if the slots in the column do not fit into the available height,
        //recalculate the slotHeight so every slot is visible
        //this way slots are squeezed - we could instead of making every slot smaller in height
        //recalculate width AND height making the whole SlotMachine smaller than the initial frame given

        if slotHeight * CGFloat(numberOfRows) > frame.size.height {
            print("fixed height")
            slotHeight = frame.size.height / CGFloat(numberOfRows)
        }

        self.slotColumnsArray = [SlotColumn]()
        self.slotColumnsRunning = [Bool]()
        self.scoreBoard = [Int]()

        //initialize all columns, and its running status to false,
        //initialize the score board as well
        for i in 0..<numberOfColumns {
            slotColumnsArray.append(
                SlotColumn(position: CGPoint(x: frame.origin.x + CGFloat(i) * (slotWidth+columnSpacing), y: frame.origin.y),
                           cardTextures: cardTextures, scene: scene,
                           numSlots: numberOfRows, slotWidth: slotWidth, slotHeight: slotHeight, slotAtIndex: slotsStartAtIndex + i,
                           spinDirection: spinDirection, waitForTime: Double(i) * 0.25))
            slotColumnsRunning.append(false)

            if i == 0 {
                scoreBoard.append(0)
            } else if i == 1 {
                scoreBoard.append(100)
            } else {
                scoreBoard.append(scoreBoard[i-1] * 5)
            }
        }
    }

    //start spining the slotMachine
    func spinNow(runForTimes: [UInt32], completion: @escaping(Int) -> Void) {
        isRunning = true

        //for all columns start spining and wait for the completion handler
        for (index, slotColumn) in slotColumnsArray.enumerated() {

            //spin column at index
            slotColumn.spinWheel(runForTimes[index]) { [weak self] resultIndices in

                //on spin done
                if let `self` = self {

                    //mark the column as done running
                    self.slotColumnsRunning[index] = false

                    //assign the results column to the correct index of the results matrix
                    self.resultIndexMatrix[index] = resultIndices

                    //when all columns finished running
                    if !self.isRunning {

                        var score: Int = 0

                        //find all wins and increent the score variable
                        self.searchForWins(&score, &self.resultIndexMatrix)

                        //pass the score to the parent / calling component
                        completion(score)
                    }
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

                    findWins(&score, columnIndex, rowIndex, &matrix, 0)
            }
        }
    }

    func findWins(_ score: inout Int, _ columnIndex: Int, _ rowIndex: Int, _ matrix: inout [[Int]], _ found: Int) {
        if columnIndex + 1 < matrix.count && matrix[columnIndex][rowIndex] == matrix[columnIndex+1][rowIndex] {
            findWins(&score, columnIndex+1, rowIndex, &matrix, found+1)
            matrix[columnIndex][rowIndex] = -1
        } else {
            if found > 0 {

                addFoundRectangle(columnIndex, rowIndex, found)

                score += self.scoreBoard[found]
            }
            matrix[columnIndex][rowIndex] = -1
        }
    }

    let fadeOut = SKAction.fadeOut(withDuration: 1.0)
    let removeFromParent = SKAction.removeFromParent()

    func addFoundRectangle(_ columnIndex: Int, _ rowIndex: Int, _ found: Int) {

        let startColumn = columnIndex - found

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
