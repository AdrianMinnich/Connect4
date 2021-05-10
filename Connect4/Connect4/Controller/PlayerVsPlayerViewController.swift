//
//  PlayerVsPlayerViewController.swift
//  Connect4
//
//  Created by Adrian Minnich on 03/05/2021.
//

import UIKit
import AVFoundation

class PlayerVsPlayerViewController: UIViewController {

    var game: Connect4Game = Connect4Game()
    
    let droppingSound: AVAudioPlayer
    let gameOverSound: AVAudioPlayer
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var whoseTurnLabel: UILabel!
    
    static let identifier = "PlayerVsPlayerViewController"
    
    required init?(coder: NSCoder) {
        let droppingSoundURL = Bundle.main.url(forResource: "drop", withExtension: "wav")!
        let gameOverSoundURL = Bundle.main.url(forResource: "gameover", withExtension: "wav")!

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("something went wrong: \(error)")
        }
        droppingSound = try! AVAudioPlayer(contentsOf: droppingSoundURL)
        droppingSound.prepareToPlay()
        
        gameOverSound = try! AVAudioPlayer(contentsOf: gameOverSoundURL)
        gameOverSound.prepareToPlay()
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardView.shadowPieces = game.pieces
        boardView.setNeedsDisplay()
    }
    
    @IBAction func didTapInBoardView(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: boardView)
        let col = boardView.columnAt(x: tapLocation.x)
        
        if game.dropAt(col: col) == true {
            updateUI()
            if let winningPieces = game.gameOverAt(col: col) {
                boardView.shadowWinningPieces = winningPieces
                boardView.setNeedsDisplay()
                if game.playerTurn == .YELLOW {
                    whoseTurnLabel.text = "Red wins"
                } else {
                    whoseTurnLabel.text = "Yellow wins"
                }
                
                boardView.isUserInteractionEnabled = false
                gameOverSound.play()
            } else {
                droppingSound.play()
            }
        }
    }
    
    @IBAction func didTapResetButton(_ sender: Any) {
        game.resetGame()
        boardView.shadowWinningPieces.removeAll()
        boardView.isUserInteractionEnabled = true
        updateUI()
        droppingSound.play()
    }
    
    func updateUI() {
        if game.playerTurn == .YELLOW {
            whoseTurnLabel.text = "Yellow's turn"
        } else {
            whoseTurnLabel.text = "Red's turn"
        }
        boardView.shadowPieces = game.pieces
        boardView.setNeedsDisplay()
    }
}
