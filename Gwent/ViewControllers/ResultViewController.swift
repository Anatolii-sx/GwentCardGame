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
        
        if AudioPlayer.shared.isMusicStop {
            AudioPlayer.shared.stopMusic()
        } else {
            AudioPlayer.shared.stopMusic()
            AudioPlayer.shared.playMusic(name: Music.victory.rawValue)
        }
        
        resultLabel.text = "\(getTheWinner()) с общим счётом побед \(winsPlayer ?? 0):\(winsComputer ?? 0)"
    }
    
    private func getTheWinner() -> String {
        var winner = ""
        
        if winsPlayer > winsComputer {
            winner = "Победил игрок 🦹🏼‍♂️"
        } else if winsPlayer < winsComputer {
            winner = "Победил компьютер 👾 "
        } else {
            winner = "Ничья 🤝"
        }
        
        return winner
    }
    

}
