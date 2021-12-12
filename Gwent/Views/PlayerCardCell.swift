//
//  CollectionViewCell.swift
//  Gwent
//
//  Created by Анатолий Миронов on 10.12.2021.
//

import UIKit

class PlayerCardCell: UICollectionViewCell {
    // MARK: - IB Outlets
    @IBOutlet var playerCardPictureLabel: UILabel!
    @IBOutlet var playerCardAttackLabel: UILabel!
    
    // MARK: - Public Method
    func configureCell(cell: UICollectionViewCell, card: Card) {
        cell.layer.cornerRadius = 3
        cell.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        playerCardAttackLabel.backgroundColor = .systemGray6
        playerCardAttackLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 255, alpha: 0.7)
        playerCardAttackLabel.layer.borderWidth = 1
        
        playerCardPictureLabel.text = "🥷"
        playerCardAttackLabel.text = "\(card.typeWarrior.attack)"
    }
}
