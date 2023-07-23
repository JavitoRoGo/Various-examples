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
    
    init() {
        boardMatrix = Array(repeating: Array(repeating: nil, count: width), count: height)
    }
}
