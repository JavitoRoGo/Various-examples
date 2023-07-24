//
//  JShape.swift
//  BlocksGame
//
//  Created by Javier Rodríguez Gómez on 24/7/23.
//

import SwiftUI

struct JShape: Shape {
    var color: Color {
        .teal
    }
    
    var occupiedPositions: [GridPosition] = [
        GridPosition(x: 4, y: -1),
        GridPosition(x: 4, y: 0, isPivot: true),
        GridPosition(x: 4, y: 1),
        GridPosition(x: 3, y: 1)
    ]
}
