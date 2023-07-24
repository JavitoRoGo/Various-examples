//
//  IShape.swift
//  BlocksGame
//
//  Created by Javier Rodríguez Gómez on 24/7/23.
//

import SwiftUI

struct IShape: Shape {
    var color: Color {
        .red
    }
    
    var occupiedPositions: [GridPosition] = [
        GridPosition(x: 4, y: -1),
        GridPosition(x: 4, y: 0),
        GridPosition(x: 4, y: 1, isPivot: true),
        GridPosition(x: 4, y: 2)
    ]
}
