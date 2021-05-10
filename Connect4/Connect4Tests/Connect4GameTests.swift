//
//  Connect4GameTests.swift
//  Connect4Tests
//
//  Created by Adrian Minnich on 03/05/2021.
//

import XCTest
@testable import Connect4

class Connect4GameTests: XCTestCase {

    func testConnect4BoardDesc() {
        let game = Connect4Game()
        print(game)
    }
    
    func testBoardWithPieces() {
        var game = Connect4Game()
        game.pieces.insert(Connect4Piece(col: 0, row: 5, color: .YELLOW))
        game.pieces.insert(Connect4Piece(col: 1, row: 5, color: .RED))
        print(game)
    }

}
