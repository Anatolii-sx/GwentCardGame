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
    private var isPlayerPassButtonTapped = false
    private var isComputerPassButtonTapped = false

    private var deckCardsPlayer: [Card] = []
    private var deckCardsComputer: [Card] = []
    
    private var currentCardsPlayer: [Card] = []
    private var currentCardsComputer: [Card] = []
    
    private var playerChosenCardsForFight: [Card] = []
    private var computerChosenCardsForFight: [Card] = []
    
    private var winsPlayer = 0
    private var winsComputer = 0
    
    private var scoreRoundPlayer = 0
    private var scoreRoundComputer = 0
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addCardsToDeck()
        getCardsFromDeck()
        
        playerChosenCardsLabel.text = "Tap a card for fight"
        computerChosenCardsLabel.text = ""
        roundLabel.text = "Round \(numberOfRound)"
        
        playerCollectionView.dataSource = self
        playerCollectionView.delegate = self
        
        computerCollectionView.dataSource = self
        computerCollectionView.delegate = self
        
        playerPassButton.layer.cornerRadius = 7
        computerPassLabel.layer.cornerRadius = 7
        computerPassLabel.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        resultVC.winsPlayer = winsPlayer
        resultVC.winsComputer = winsComputer
    }
    
    // MARK: - IB Actions
    @IBAction func playerPassButtonTapped() {
        isPlayerPassButtonTapped = true
        playerPassButton.backgroundColor = .systemRed
        playerPassButton.tintColor = .white
        playerPassButton.isEnabled = false
        
        makeComputerDecisionAfterPlayerPassButtonTapped()
        delay(200) { [self] in
            self.checkButtonsStatus()
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        startNewGame()
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
        if collectionView == playerCollectionView && !isPlayerPassButtonTapped {
            playerChosenCardsForFight.append(currentCardsPlayer[indexPath.row])
            currentCardsPlayer.remove(at: indexPath.row)
            playerCollectionView.deleteItems(at: [indexPath])
            addPlayerCardsToLabel()
            makeComputerDecision()
            delay(200) { [self] in
                self.checkCurrentCardsEmpty()
            }
        } else if collectionView == computerCollectionView {
            print("Don't try to play instead computer 🙂")
        }
    }
    
    // MARK: - Private methods of interaction with a deck
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
    
    private func startNewGame() {
        clearDecks()
        clearCurrentCards()
        clearWins()
        addCardsToDeck()
        numberOfRound = 0
        delay(200) { [self] in
            self.startNewRound()
        }
    }
    
    private func clearDecks() {
        deckCardsPlayer = []
        deckCardsComputer = []
    }
    
    private func clearCurrentCards() {
        currentCardsPlayer = []
        currentCardsComputer = []
    }
    
    private func clearWins() {
        winsPlayer = 0
        winsComputer = 0
    }

    // MARK: - Other Private Methods
    private func addPlayerCardsToLabel() {
        let cards = playerChosenCardsForFight.map { String($0.typeWarrior.attack) + "🥷" }
        playerChosenCardsLabel.text = cards.joined(separator: "  ")
    }
    
    private func updateProgressView () {
        let progressValue = Float(numberOfRound) / 3
        progressView.setProgress(progressValue, animated: true)
    }
    
    private func checkButtonsStatus() {
        if isPlayerPassButtonTapped && isComputerPassButtonTapped {
            getResult()
            startNewRound()
        }
    }
    
    private func startNewRound() {
        
        if numberOfRound < 3 {
            updateProgressView()
            numberOfRound += 1
            roundLabel.text = "Round \(numberOfRound)"
            clearChosenCards()
            getCardsFromDeck()
            reloadCollectionViews()
            clearTappedFromButtons()
        } else {
            delay(150) { [self] in
                self.clearTappedFromButtons()
                self.performSegue(withIdentifier: "resultSegue", sender: nil)
            }
        }
    }
    
    private func clearChosenCards() {
        playerChosenCardsForFight = []
        playerChosenCardsLabel.text = ""
        
        computerChosenCardsForFight = []
        computerChosenCardsLabel.text = ""
    }
    
    private func reloadCollectionViews() {
        playerCollectionView.reloadData()
        computerCollectionView.reloadData()
    }
    
    private func clearTappedFromButtons() {
        isPlayerPassButtonTapped = false
        playerPassButton.isEnabled = true
        playerPassButton.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.5882352941, blue: 0.7098039216, alpha: 0.6161009934)
        playerPassButton.tintColor = .black
        
        isComputerPassButtonTapped = false
        computerPassLabel.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.5882352941, blue: 0.7098039216, alpha: 0.6161009934)
        computerPassLabel.textColor = .black
    }
    
    private func getResult() {
        var winner = ""
        
        if numberOfRound <= 3 {
            let playerListOfAttack = playerChosenCardsForFight.map { $0.typeWarrior.attack }
            scoreRoundPlayer = playerListOfAttack.reduce(0, +)
            
            let computerListOfAttack = computerChosenCardsForFight.map { $0.typeWarrior.attack }
            scoreRoundComputer = computerListOfAttack.reduce(0, +)
            
            if scoreRoundPlayer > scoreRoundComputer {
                winsPlayer += 1
                winner = "Player 🦹🏼‍♂️"
            } else if scoreRoundPlayer < scoreRoundComputer {
                winsComputer += 1
                winner = "Computer 👾"
            } else {
                winner = "No one 🤝"
            }
        }
        
        if numberOfRound < 3 {
            showAlert(title: "Round \(numberOfRound) is finished", message: "The winner is: \(winner) with score \(scoreRoundPlayer):\(scoreRoundComputer)")
        }
    }
    
    private func checkCurrentCardsEmpty() {
        checkCurrentCardsPlayerEmpty()
        checkCurrentCardsComputerEmpty()
        checkButtonsStatus()
    }
    
    private func checkCurrentCardsPlayerEmpty() {
        currentCardsPlayer.isEmpty ? playerPassButtonTapped() : nil
    }
    
    private func checkCurrentCardsComputerEmpty() {
        if currentCardsComputer.isEmpty {
            isComputerPassButtonTapped = true
            changeColorOfComputerPassButton()
        }
    }
    
    private func delay(_ delay: Int, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            completion()
        }
    }
}


 // MARK: - Computer Logic of making decision
extension GameViewController {
    private func makeComputerDecisionAfterPlayerPassButtonTapped() {
        if playerChosenCardsForFight.isEmpty {
            makeComputerDecision()
            isComputerPassButtonTapped = true
        } else if numberOfRound == 3 {
            while
                !isComputerPassButtonTapped
                && !currentCardsComputer.isEmpty {
                makeComputerDecision()
            }
            if isPlayerPassButtonTapped {
                isComputerPassButtonTapped = true
                changeColorOfComputerPassButton()
            }
        } else {
            while
                !isComputerPassButtonTapped
                && !currentCardsComputer.isEmpty
                && computerChosenCardsForFight.count <= playerChosenCardsForFight.count + 2 {
                makeComputerDecision()
            }
            if isPlayerPassButtonTapped {
                isComputerPassButtonTapped = true
                changeColorOfComputerPassButton()
            }
        }
    }
    
    private func makeComputerDecision() {
        getRandomComputerDecisionOfMoving()
        
        if !isComputerPassButtonTapped && !currentCardsComputer.isEmpty {
            let indexCard = addComputerCardsToLabel()
            
            currentCardsComputer.remove(at: indexCard)
            let numberOfCard = IndexPath(item: indexCard, section: 0)
            computerCollectionView.deleteItems(at: [numberOfCard])
        }
    }
    
    private func addComputerCardsToLabel() -> Int {
        var randomCardNumber = 0
        
        if !isComputerPassButtonTapped && !currentCardsComputer.isEmpty {
            let countOfCards = currentCardsComputer.count
            randomCardNumber = Int.random(in: 0..<countOfCards)
            
            computerChosenCardsForFight.append(currentCardsComputer[randomCardNumber])
            let cards = computerChosenCardsForFight.map { String($0.typeWarrior.attack) + "🧟‍♂️" }
            computerChosenCardsLabel.text = cards.joined(separator: "  ")
        }
        
        return randomCardNumber
    }
    
    private func getRandomComputerDecisionOfMoving() {
        if playerChosenCardsForFight.count <= 1 {
            isComputerPassButtonTapped = false
        } else if numberOfRound == 3 {
            isComputerPassButtonTapped = false
        } else if !isComputerPassButtonTapped {
            let randomChoice = Int.random(in: 0...10)
            isComputerPassButtonTapped = randomChoice > 9 ? true: false
            changeColorOfComputerPassButton()
        }
    }
    
    private func changeColorOfComputerPassButton() {
        if isComputerPassButtonTapped {
            computerPassLabel.backgroundColor = .systemRed
            computerPassLabel.textColor = .white
        }
    }
}

 // MARK: - Alert Controller
extension GameViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        present(alert, animated: true)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
    }
}

