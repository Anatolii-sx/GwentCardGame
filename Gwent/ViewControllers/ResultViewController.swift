//
//  ResultViewController.swift
//  Gwent
//
//  Created by Анатолий Миронов on 12.12.2021.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet var resultLabel: UILabel!
    
    var winsPlayer: Int!
    var winsComputer: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "\(getTheWinner()) won with score by rounds \(winsPlayer ?? 0):\(winsComputer ?? 0)"
    }
    
    private func getTheWinner() -> String {
        var winner = ""
        
        if winsPlayer > winsComputer {
            winner = "Player 🦹🏼‍♂️"
        } else if winsPlayer < winsComputer {
            winner = "Computer 👾"
        } else {
            winner = "No one 🤝"
        }
        
        return winner
    }
    

}
