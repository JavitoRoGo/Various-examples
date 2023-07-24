//
//  LShape.swift
//  BlocksGame
//
//  Created by Javier Rodríguez Gómez on 24/7/23.
//

import SwiftUI

struct LShape: Shape {
    var color: Color {
        .blue
    }
    
    var occupiedPositions: [GridPosition] = [
        GridPosition(x: 4, y: -1),
        GridPosition(x: 4, y: 0, isPivot: true),
        GridPosition(x: 4, y: 1),
        GridPosition(x: 5, y: 1)
    ]
}
