//
//  PeerToPeerViewController.swift
//  Connect4
//
//  Created by Adrian Minnich on 07/05/2021.
//

import UIKit
import AVFoundation
import MultipeerConnectivity

class PeerToPeerViewController: UIViewController {
    
    var game: Connect4Game = Connect4Game()
    
    let droppingSound: AVAudioPlayer
    let gameOverSound: AVAudioPlayer
    
    var peerID: MCPeerID!
    var session: MCSession!
    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var whoseTurnLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    static let identifier = "PeerToPeerViewController"
    
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
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID)
        session.delegate = self
        
        let alert = UIAlertController(title: "Choose whether you would like to create a game or join an existing one.",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { [self] action in
            
            let browser = MCBrowserViewController(serviceType: "connect4", session: self.session)
            browser.delegate = self
            present(browser, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [self] action in
            
            nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "connect4")
            
            nearbyServiceAdvertiser.delegate = self
            nearbyServiceAdvertiser.startAdvertisingPeer()
            
            let innerAlert = UIAlertController(title: "Game has been created", message: "", preferredStyle: .alert)
            innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            present(innerAlert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true, completion: nil)
        
        boardView.shadowPieces = game.pieces
        boardView.setNeedsDisplay()
        
        
    }
    
    @IBAction func didTapInBoardView(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: boardView)
        let col = boardView.columnAt(x: tapLocation.x)
        
        if updateDropAt(col: col) {
            let msg = "\(col)"
            if let msgData = msg.data(using: .utf8) {
                try? session.send(msgData, toPeers: session.connectedPeers, with: .reliable)
            }
        }
    }
    
    @IBAction func didTapResetButton(_ sender: Any) {
        resetGame()
        let msg = "reset"
        if let msgData = msg.data(using: .utf8) {
            try? session.send(msgData, toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
    func resetGame() {
        game.resetGame()
        boardView.shadowWinningPieces.removeAll()
        boardView.isUserInteractionEnabled = true
        updateUI()
        droppingSound.play()
    }
    
    func updateDropAt(col: Int) -> Bool {
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
            return true
        }
        return false
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

extension PeerToPeerViewController: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            fatalError()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let msg = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                if msg == "reset" {
                    self.resetGame()
                }
                else {
                    if let col = Int(msg) {
                        _ = self.updateDropAt(col: col)
                    }
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

extension PeerToPeerViewController: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension PeerToPeerViewController: MCNearbyServiceAdvertiserDelegate {
 
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}
