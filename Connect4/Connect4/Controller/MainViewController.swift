//
//  MainViewController.swift
//  Connect4
//
//  Created by Adrian Minnich on 03/05/2021.
//

import UIKit

class MainViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapPlayerVsPlayerLocalButton(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: PlayerVsPlayerViewController.identifier) as! PlayerVsPlayerViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapPlayerVsPlayerOnlineButton(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: PeerToPeerViewController.identifier) as! PeerToPeerViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapPlayerVsAiButton(_ sender: Any) {
        // TODO: implement minimax algorithm
    }
}
