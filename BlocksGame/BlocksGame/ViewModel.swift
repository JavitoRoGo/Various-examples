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
	
	@Published var score: Int = 0
	@Published var level: Int = 1
	@Published var lines: Int = 0
	
	private var linePerLevel: Int = 5
	private var linesToLevelUp: Int = 5
	@Published var speed: Double = 0.5
    
    @Published var boardMatrix: [[SquareGame?]]
    @Published var activeShape: Shape? = nil
	@Published var nextActiveShape: Shape? = nil
	
	@Published var gameIsOver: Bool = false
	@Published var gameIsStopped: Bool = true
    
    var timer = Timer.publish(every: 0.5, on: .main, in: .common)
    var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        boardMatrix = Array(repeating: Array(repeating: nil, count: width), count: height)
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
			if gameIsOver || gameIsStopped {
				return
			}
            activeShape?.moveUp()
            if isOverLimit(shape: activeShape!) {
				gameOver()
                return
            }
            
            landShape()
        }
    }
    
    func landShape() {
        if let activeShape {
            storeShapeInGrid(shape: activeShape)
            
            let cleared = clearAllRows()
			
			score += calculateScore(linesCleared: cleared, level: level)
			
			lines += cleared
			
			linesToLevelUp -= cleared
			if linesToLevelUp <= 0 {
				levelUp()
			}
        }
    }
    
    func storeShapeInGrid(shape: Shape) {
        if isInvalidPosition(shape: shape) {
            for position in shape.occupiedPositions {
                boardMatrix[position.y][position.x] = SquareGame(x: position.x, y: position.y, occupied: true, color: shape.color)
            }
        }
        activeShape = nextActiveShape
		nextActiveShape = createRandomShape()
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
	
	func calculateScore(linesCleared: Int, level: Int) -> Int {
		//clear one line --> 40 points x level
		//clear two lines --> 100 points x level
		//clear three lines --> 300 points x level
		// clear four lines --> 1200 points x level
		var score = 0
		switch linesCleared {
			case 1: score = 40 * level
			case 2: score = 100 * level
			case 3: score = 300 * level
			case 4: score = 1200 * level
			default: score = 0
		}
		return score
	}
	
	func levelUp() {
		level += 1
		linesToLevelUp = level * linePerLevel
		
		if speed >= 0.1 {
			speed -= 0.05
			cancellableSet = []
			timer = Timer.publish(every: speed, on: .main, in: .common)
			timer
				.autoconnect().sink { timer in
					self.moveDown()
				}.store(in: &cancellableSet)
		}
	}
	
	func gameOver() {
		gameIsOver = true
		gameIsStopped = true
		activeShape = nil
		nextActiveShape = nil
		
		boardMatrix = Array(repeating: Array(repeating: nil, count: width), count: height)
	}
	
	func restartGame() {
		cancellableSet = []
		
		level = 1
		lines = 0
		score = 0
		speed = 0.5
		linesToLevelUp = 5
		
		timer
			.autoconnect()
			.sink { timer in
				self.moveDown()
			}
			.store(in: &cancellableSet)
		
		gameIsOver = false
		gameIsStopped = false
		
		boardMatrix = Array(repeating: Array(repeating: nil, count: width), count: height)
		
		if activeShape == nil {
			activeShape = createRandomShape()
			nextActiveShape = createRandomShape()
		}
	}
}
