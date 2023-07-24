//
//  Shape.swift
//  BlocksGame
//
//  Created by Javier Rodríguez Gómez on 24/7/23.
//

import Foundation
import SwiftUI

protocol Shape {
    var color: Color { get }
    var occupiedPositions: [GridPosition] { get set }
    
    mutating func moveDown()
    mutating func moveUp()
    mutating func moveLeft()
    mutating func moveRight()
    
    mutating func rotateToRight()
    mutating func rotateToLeft()
    
    func isInPosition(x: Int, y: Int) -> Bool
}

extension Shape {
    func isInPosition(x: Int, y: Int) -> Bool {
        return occupiedPositions.first { item in
            item.x == x && item.y == y
        } != nil
    }
}

extension Shape {
    mutating func moveDown() {
        for index in occupiedPositions.indices {
            occupiedPositions[index].y += 1
        }
    }
    
    mutating func moveUp() {
        for index in occupiedPositions.indices {
            occupiedPositions[index].y -= 1
        }
    }
}

extension Shape {
    mutating func moveLeft() {
        for index in occupiedPositions.indices {
            occupiedPositions[index].x -= 1
        }
    }
    
    mutating func moveRight() {
        for index in occupiedPositions.indices {
            occupiedPositions[index].x += 1
        }
    }
}

extension Shape {
    mutating func rotateToRight() {
        if let pivot = occupiedPositions.first(where: { $0.isPivot == true }) {
            let px = pivot.x
            let py = pivot.y
            
            for index in occupiedPositions.indices {
                let y1 = occupiedPositions[index].y
                let x1 = occupiedPositions[index].x
                
                let x2 = (y1 + px - py)
                let y2 = (px + py - x1)
                
                occupiedPositions[index].x = x2
                occupiedPositions[index].y = y2
            }
        }
    }
    
    mutating func rotateToLeft() {
        if let pivot = occupiedPositions.first(where: { $0.isPivot == true }) {
            let px = pivot.x
            let py = pivot.y
            
            for index in occupiedPositions.indices {
                let y1 = occupiedPositions[index].y
                let x1 = occupiedPositions[index].x
                
                let x2 = (px + py - y1)
                let y2 = (x1 + py - px)
                
                occupiedPositions[index].x = x2
                occupiedPositions[index].y = y2
            }
        }
    }
}
