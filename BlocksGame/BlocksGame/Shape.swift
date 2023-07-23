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
    
    mutating func rotateRight()
    mutating func rotateLeft()
    
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
        // voy por 8:25
    }
}
