//
//  ViewController.swift
//  Gwent
//
//  Created by Анатолий Миронов on 09.12.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    let cards = Card.getCardsForPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards.forEach{
            print($0.type.attack)
        }
    }
}

