//
//  Connect4Game.swift
//  Connect4
//
//  Created by Adrian Minnich on 03/05/2021.
//

import Foundation

struct Connect4Game: CustomStringConvertible {
    
    static let cols = 7
    static let rows = 6
    
    var pieces: Set<Connect4Piece> = Set<Connect4Piece>()
    var playerTurn: PlayerColor = .YELLOW
    
    var description: String {
        var desc = "  "
        
        for col in 0..<Connect4Game.cols {
            desc += "\(col) "
        }
        
        desc += "\n"
        
        for row in 0..<Connect4Game.rows {
            desc += "\(row) "
            for col in 0..<Connect4Game.cols {
                let piece = pieceAt(col: col, row: row)
                if piece == nil {
                    desc += ". "
                } else {
                    if piece!.color == .RED {
                        desc += "o "
                    } else {
                        desc += "x "
                    }
                }
            }
            desc += "\n"
        }
        
        return desc
    }
    
    func pieceAt(col: Int, row: Int) -> Connect4Piece? {
        for piece in pieces {
            if row == piece.row && col == piece.col {
                return piece
            }
        }
        return nil
    }
    
    func numberOfPieces(col: Int) -> Int {
        var numberOfPieces = 0
        for piece in pieces where piece.col == col {
            numberOfPieces += 1
        }
        return numberOfPieces
    }
    
    mutating func dropAt(col: Int) -> Bool {
        if numberOfPieces(col: col) >= Connect4Game.rows {
            return false
        }
        let numberOfPieces = numberOfPieces(col: col)
        let row = Connect4Game.rows - 1 - numberOfPieces
        let newPiece: Connect4Piece
        
        if playerTurn == .YELLOW {
            newPiece = Connect4Piece(col: col, row: row, color: .YELLOW)
        } else {
            newPiece = Connect4Piece(col: col, row: row, color: .RED)
        }

        pieces.insert(newPiece)
        
        if playerTurn == .YELLOW {
            playerTurn = .RED
        } else {
            playerTurn = .YELLOW
        }
        return true
    }
    
    func fourConnectedAt(col: Int, row: Int, color: PlayerColor) -> Set<Connect4Piece>? {
        var horizontalBox: Set<Connect4Piece> = Set<Connect4Piece>()
        var verticalBox: Set<Connect4Piece> = Set<Connect4Piece>()
        var diagonalTLBRBox: Set<Connect4Piece> = Set<Connect4Piece>()
        var diagonalBLTRBox: Set<Connect4Piece> = Set<Connect4Piece>()
        
        for i in 1...3 {
            if let piece = pieceAt(col: col - i, row: row), piece.color == color {
                horizontalBox.insert(piece)
            }
            if let piece = pieceAt(col: col - i, row: row + i), piece.color == color {
                diagonalBLTRBox.insert(piece)
            }
            if let piece = pieceAt(col: col, row: row + i), piece.color == color {
                verticalBox.insert(piece)
            }
            if let piece = pieceAt(col: col + i, row: row + i), piece.color == color {
                diagonalTLBRBox.insert(piece)
            }
            if let piece = pieceAt(col: col + i, row: row), piece.color == color {
                horizontalBox.insert(piece)
            }
            if let piece = pieceAt(col: col + i, row: row - i), piece.color == color {
                diagonalBLTRBox.insert(piece)
            }
            if let piece = pieceAt(col: col, row: row - i), piece.color == color {
                verticalBox.insert(piece)
            }
            if let piece = pieceAt(col: col - i, row: row - i), piece.color == color {
                diagonalTLBRBox.insert(piece)
            }
            
            if horizontalBox.count == 3 {
                horizontalBox.insert(pieceAt(col: col, row: row)!)
                return horizontalBox
            } else if verticalBox.count == 3 {
                verticalBox.insert(pieceAt(col: col, row: row)!)
                return verticalBox
            } else if diagonalTLBRBox.count == 3 {
                diagonalTLBRBox.insert(pieceAt(col: col, row: row)!)
                return diagonalTLBRBox
            } else if diagonalBLTRBox.count == 3 {
                diagonalBLTRBox.insert(pieceAt(col: col, row: row)!)
                return diagonalBLTRBox
            }
        }
        return nil
    }
    
    func gameOverAt(col: Int) -> Set<Connect4Piece>? {
        let row = Connect4Game.rows - numberOfPieces(col: col)
        if (playerTurn == .YELLOW) {
            return fourConnectedAt(col: col, row: row, color: .RED)
        } else {
            return fourConnectedAt(col: col, row: row, color: .YELLOW)
        }
    }

    mutating func resetGame() {
        pieces.removeAll()
        playerTurn = .YELLOW
    }
}
