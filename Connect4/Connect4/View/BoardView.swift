//
//  BoardView.swift
//  Connect4
//
//  Created by Adrian Minnich on 03/05/2021.
//

import UIKit

class BoardView: UIView {

    let boardToScreenRatio: CGFloat = 0.95
    var originX: CGFloat = 20
    var originY: CGFloat = 20
    var squareSize: CGFloat = 40
    
    var shadowPieces: Set<Connect4Piece> = Set<Connect4Piece>()
    var shadowWinningPieces: Set<Connect4Piece> = Set<Connect4Piece>()

    override func draw(_ rect: CGRect) {
        let boardWidth = bounds.width * boardToScreenRatio
        squareSize = boardWidth / CGFloat(Connect4Game.cols)
        originX = (1 - boardToScreenRatio) * bounds.width / 2
        originY = (bounds.height - CGFloat(Connect4Game.rows) * squareSize) / 2
        drawBoard()
        drawPieces()
    }
    
    func columnAt(x: CGFloat) -> Int {
        return Int((x - originX) / squareSize)
    }
    
    func drawBoard() {
        let boardPath = UIBezierPath(roundedRect: CGRect(x: originX, y: originY, width: CGFloat(Connect4Game.cols) * squareSize, height: CGFloat(Connect4Game.rows) * squareSize), cornerRadius: 0.25 * squareSize)
        boardPath.stroke()
        UIColor.blue.setFill()
        boardPath.fill()
        
        UIColor.white.setFill()
        for row in 0..<Connect4Game.rows {
            for col in 0..<Connect4Game.cols {
                drawCircle(row: row, col: col, color: .white, withStroke: false)
            }
        }
    }
    
    func drawCircle(row: Int, col: Int, color: UIColor, withStroke: Bool) {
        color.setFill()
        let circleCenterX: CGFloat = originX + 0.5 * squareSize + CGFloat(col) * squareSize
        let circleCenterY: CGFloat = originY + 0.5 * squareSize + CGFloat(row) * squareSize
        let circle = UIBezierPath(arcCenter: CGPoint(x: circleCenterX, y: circleCenterY), radius: 0.4 * squareSize, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        circle.fill()
        if withStroke {
            UIColor.green.setStroke()
            circle.lineWidth = 3
            circle.stroke()
        }
    }
    
    func drawPieces() {
        for piece in shadowPieces {
            if piece.color == .YELLOW {
                drawCircle(row: piece.row, col: piece.col, color: .yellow, withStroke: false)
            } else if piece.color == .RED {
                drawCircle(row: piece.row, col: piece.col, color: .red, withStroke: false)
            }
        }
        for piece in shadowWinningPieces {
            if piece.color == .YELLOW {
                drawCircle(row: piece.row, col: piece.col, color: .yellow, withStroke: true)
            } else if piece.color == .RED {
                drawCircle(row: piece.row, col: piece.col, color: .red, withStroke: true)
            }
        }
    }
}
