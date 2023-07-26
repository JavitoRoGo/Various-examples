//
//  ViewModel.swift
//  BlocksGame
//
//  Created by Javier Rodríguez Gómez on 23/7/23.
//

import Combine
import SwiftUI

final class ViewModel: ObservableObject {
    let width: Int = 10
    let height: Int = 26
    
    @Published var boardMatrix: [[SquareGame?]]
    @Published var activeShape: Shape? = nil
    
    var timer = Timer.publish(every: 0.5, on: .main, in: .common)
    var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        boardMatrix = Array(repeating: Array(repeating: nil, count: width), count: height)
        
        if activeShape == nil {
            activeShape = createRandomShape()
        }
        
        timer
            .autoconnect()
            .sink { timer in
                self.moveDown()
            }
            .store(in: &cancellableSet)
    }
    
    private func getSquareGameInMatrix(x: Int, y: Int) -> SquareGame? {
        if y >= 0, x >= 0, y < height, x < width {
            return boardMatrix[y][x]
        } else {
            return nil
        }
    }
    
    func getSquareGame(x: Int, y: Int) -> SquareGame? {
        if let activeShape, activeShape.isInPosition(x: x, y: y) {
            return SquareGame(x: x, y: y, color: activeShape.color)
        }
        
        if let squareGame = getSquareGameInMatrix(x: x, y: y), squareGame.occupied {
            return squareGame
        }
        
        return nil
    }
    
    func moveDown() {
        activeShape?.moveDown()
        
        if let shape = activeShape, !isInvalidPosition(shape: shape) {
            activeShape?.moveUp()
            if isOverLimit(shape: activeShape!) {
                return
            }
            
            landShape()
        }
    }
    
    func landShape() {
        if let activeShape {
            storeShapeInGrid(shape: activeShape)
            
            let cleared = clearAllRows()
        }
    }
    
    func storeShapeInGrid(shape: Shape) {
        if isInvalidPosition(shape: shape) {
            for position in shape.occupiedPositions {
                boardMatrix[position.y][position.x] = SquareGame(x: position.x, y: position.y, occupied: true, color: shape.color)
            }
        }
        activeShape = createRandomShape()
    }
    
    func moveLeft() {
        activeShape?.moveLeft()
        
        if let shape = activeShape, !isInvalidPosition(shape: shape) {
            activeShape?.moveRight()
        }
    }
    
    func moveRight() {
        activeShape?.moveRight()
        
        if let shape = activeShape, !isInvalidPosition(shape: shape) {
            activeShape?.moveLeft()
        }
    }
    
    func rotateShape() {
        activeShape?.rotateToLeft()
        
        if let shape = activeShape, !isInvalidPosition(shape: shape) {
            activeShape?.rotateToRight()
        }
    }
    
    func createRandomShape() -> Shape {
        let value = Int.random(in: 0..<7)
        
        switch value {
        case 0: return OShape()
        case 1: return IShape()
        case 2: return TShape()
        case 3: return LShape()
        case 4: return JShape()
        case 5: return SShape()
        case 6: return ZShape()
        default: return OShape()
        }
    }
    
    func isInvalidPosition(shape: Shape) -> Bool {
        for position in shape.occupiedPositions {
            if !isWithInBoard(x: position.x, y: position.y) {
                return false
            }
            if isOccupied(x: position.x, y: position.y) {
                return false
            }
        }
        return true
    }
    
    func isWithInBoard(x: Int, y: Int) -> Bool {
        if x < width, y < height, x >= 0 {
            return true
        }
        return false
    }
    
    func isOccupied(x: Int, y: Int) -> Bool {
        if let squareGame = getSquareBoard(x: x, y: y), squareGame.occupied {
            return true
        }
        return false
    }
    
    private func getSquareBoard(x: Int, y: Int) -> SquareGame? {
        if y >= 0, x >= 0, y < height, x < width {
            return boardMatrix[y][x]
        } else {
            return nil
        }
    }
    
    func isOverLimit(shape: Shape) -> Bool {
        for position in shape.occupiedPositions {
            if position.y <= -1 || position.y >= height {
                return true
            }
        }
        return false
    }
    
    func clearAllRows() -> Int {
        var cleared = 0
        for (index, item) in boardMatrix.enumerated() {
            if isRowComplete(y: index) {
                clearRow(y: index)
                shiftRowsDown(end: index)
                
                cleared += 1
            }
        }
        return cleared
    }
    
    func isRowComplete(y: Int) -> Bool {
        boardMatrix[y].filter { squaregame in
            squaregame == nil || squaregame?.occupied == false
        }.count == 0
    }
    
    func clearRow(y: Int) {
        for index in boardMatrix[y].indices {
            boardMatrix[y][index] = nil
        }
    }
    
    func shiftRowsDown(end: Int) {
        for index in (0..<end).reversed() {
            shiftOneRowDown(y: index)
        }
    }
    
    func shiftOneRowDown(y: Int) {
        for index in boardMatrix[y].indices {
            if let squaregame = boardMatrix[y][index] {
                boardMatrix[y + 1][index] = SquareGame(x: squaregame.x, y: squaregame.y, occupied: squaregame.occupied, color: squaregame.color)
            } else {
                boardMatrix[y + 1][index] = nil
            }
            boardMatrix[y][index] = nil
        }
    }
}
