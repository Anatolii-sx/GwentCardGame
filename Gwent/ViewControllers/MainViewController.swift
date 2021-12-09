//
//  ViewController.swift
//  Gwent
//
//  Created by Анатолий Миронов on 09.12.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private var numberOfRound = 1
    
    private var deckCardsPlayer: [Card] = []
    private var deckCardsComputer: [Card] = []
    
    private var currentCardsPlayer: [Card] = []
    private var currentCardsComputer: [Card] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addCardsToDeck()
        getCardsFromDeck()

//        deckCardsPlayer.forEach{
//            print($0.type.attack)
//        }
//
//        deckCardsComputer.forEach{
//            print("Comp \($0.type.attack)")
//        }
    }
    
    private func addCardsToDeck() {
        deckCardsPlayer = Card.getCardsForGame()
        deckCardsComputer = Card.getCardsForGame()
    }
    
    private func getCardsFromDeck() {
        if numberOfRound == 1 {
            getCardsFromPlayerDeck(count: 5)
            getCardsFromComputerDeck(count: 5)
        } else if numberOfRound == 2 || numberOfRound == 3 {
            getCardsFromPlayerDeck(count: 3)
            getCardsFromComputerDeck(count: 3)
        } else {
            clearDecks()
            addCardsToDeck()
        }
    }
    
    private func getCardsFromPlayerDeck(count: Int) {
        for _ in 1...count {
            guard let card = deckCardsPlayer.first else { return }
            currentCardsPlayer.append(card)
            deckCardsPlayer.removeFirst()
        }
    }
    
    private func getCardsFromComputerDeck(count: Int) {
        for _ in 1...count {
            guard let card = deckCardsComputer.first else { return }
            currentCardsComputer.append(card)
            deckCardsComputer.removeFirst()
        }
    }
    
    private func clearDecks() {
        deckCardsPlayer = []
        deckCardsComputer = []
    }
}

