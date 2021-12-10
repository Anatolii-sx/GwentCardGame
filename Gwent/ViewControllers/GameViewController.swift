//
//  ViewController.swift
//  Gwent
//
//  Created by Анатолий Миронов on 09.12.2021.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - IB Outlets
    @IBOutlet weak var progressView: UIProgressView!
   
    @IBOutlet weak var playerCollectionView: UICollectionView!
    @IBOutlet weak var computerCollectionView: UICollectionView!
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var computerPassLabel: UILabel!
    @IBOutlet weak var playerChosenCardsLabel: UILabel!
    @IBOutlet weak var computerChosenCardsLabel: UILabel!
    
    @IBOutlet weak var playerPassButton: UIButton!
    
    // MARK: - Private Properties
    private var numberOfRound = 1
    private var isPlayerPassedButtonTapped = false
    private var isComputerPassedButtonTapped = false

    private var deckCardsPlayer: [Card] = []
    private var deckCardsComputer: [Card] = []
    
    private var currentCardsPlayer: [Card] = []
    private var currentCardsComputer: [Card] = []
    
    private var playerChosenCardsForFight: [Card] = []
    private var computerChosenCardsForFight: [Card] = []
    

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addCardsToDeck()
        getCardsFromDeck()
        
        playerChosenCardsLabel.text = ""
        computerChosenCardsLabel.text = ""
        roundLabel.text = "Round \(numberOfRound)"
        
        playerCollectionView.dataSource = self
        playerCollectionView.delegate = self
        
        computerCollectionView.dataSource = self
        computerCollectionView.delegate = self
        
        playerPassButton.layer.cornerRadius = 7
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
    
    // MARK: - IB Actions
    @IBAction func passedButtonTapped() {
        isPlayerPassedButtonTapped.toggle()
        playerPassButton.backgroundColor = .systemRed
        playerPassButton.tintColor = .white
    }
    
    // MARK: - Public Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == playerCollectionView ? currentCardsPlayer.count : currentCardsComputer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == playerCollectionView {
            guard let playerCell = playerCollectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as? PlayerCardCell else { return cell }
            let card = currentCardsPlayer[indexPath.row]
            playerCell.configureCell(cell: playerCell, card: card)
            cell = playerCell
        } else {
            guard let computerCell = computerCollectionView.dequeueReusableCell(withReuseIdentifier: "computerCell", for: indexPath) as? ComputerCardCell else { return cell }
            let card = currentCardsComputer[indexPath.row]
            computerCell.configureCell(cell: computerCell, card: card)
            cell = computerCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == playerCollectionView && !isPlayerPassedButtonTapped {
            playerChosenCardsForFight.append(currentCardsPlayer[indexPath.row])
            currentCardsPlayer.remove(at: indexPath.row)
            playerCollectionView.deleteItems(at: [indexPath])
            addPlayerCardsToLabel()
            
            
            // Computer
            let indexOfChosenCardComputer = moveOfComputer()
            let indexPathOfChosenCardComputer = IndexPath(index: indexOfChosenCardComputer)
            
            computerChosenCardsForFight.append(currentCardsComputer[indexOfChosenCardComputer])
            currentCardsComputer.remove(at: indexOfChosenCardComputer)
            
            let number = IndexPath(item: indexOfChosenCardComputer, section: 0)
            computerCollectionView.deleteItems(at: [number])
            
        }
    }
    
    // MARK: - Private Methods
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
    
    private func addPlayerCardsToLabel() {
        let cards = playerChosenCardsForFight.map { String($0.typeWarrior.attack) + "🥷" }
        playerChosenCardsLabel.text = cards.joined(separator: "  ")
    }
    
    private func moveOfComputer() -> Int {
        var randomCardNumber = 0
        getRandomComputerChoiceOfMoving()
        
        if !isComputerPassedButtonTapped {
            let countOfCards = currentCardsComputer.count
            randomCardNumber = Int.random(in: 0...countOfCards)
            
            let cards = computerChosenCardsForFight.map { String($0.typeWarrior.attack) + "🧟‍♂️" }
            computerChosenCardsLabel.text = cards.joined(separator: "  ")
        }
        
        return randomCardNumber
    }
    
    private func getRandomComputerChoiceOfMoving() {
        if !isComputerPassedButtonTapped {
            let randomChoice = Int(Double.random(in: 0...1))
            print(randomChoice)
            isComputerPassedButtonTapped = randomChoice == 1 ? true: false
            if isComputerPassedButtonTapped {
                computerPassLabel.backgroundColor = .systemRed
                computerPassLabel.textColor = .white
            }
        }
    }
    
    private func updateProgressView () {
        let progressValue = Float(numberOfRound) / 3
        progressView.setProgress(progressValue, animated: true)
    }
}

