//
//  Connect4Piece.swift
//  Connect4
//
//  Created by Adrian Minnich on 03/05/2021.
//

import Foundation

struct Connect4Piece: Hashable {
    let col: Int
    let row: Int
    let color: PlayerColor
}

enum PlayerColor {
    case YELLOW
    case RED
}
