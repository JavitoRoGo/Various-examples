//
//  SquareGame.swift
//  BlocksGame
//
//  Created by Javier Rodríguez Gómez on 24/7/23.
//

import Combine
import SwiftUI

struct SquareGame {
    var x: Int
    var y: Int
    var occupied: Bool = false
    var color: Color? = nil
}
