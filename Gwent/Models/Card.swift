//
//  Card.swift
//  Gwent
//
//  Created by Анатолий Миронов on 09.12.2021.
//

struct Card {
    let typeWarrior: Warrior
}

struct Warrior {
    let attack: Int
}

extension Card {
    static func getCardsForGame() -> [Card] {
        let groupOne = getCards(count: 2, with: 6)
        let groupTwo = getCards(count: 3, with: 4)
        let groupThree = getCards(count: 5, with: 2)
        let groupFour = getCards(count: 10, with: 1)
        
        let cards = groupOne + groupTwo + groupThree + groupFour
        return cards.shuffled()
    }
    
    static private func getCards(count: Int, with warriorAttack: Int) -> [Card] {
        var cards: [Card] = []
        for _ in 1...count {
            cards.append(
                Card(typeWarrior: Warrior(attack: warriorAttack))
            )
        }
        return cards
    }
}
