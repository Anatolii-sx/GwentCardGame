//
//  StartViewController.swift
//  Gwent
//
//  Created by Анатолий Миронов on 12.12.2021.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AudioPlayer.shared.playMusic(name: Music.main.rawValue)
    }
    
}
