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
        cell.backgroundColor = .systemGray3
        playerCardAttackLabel.backgroundColor = .white
        playerCardAttackLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
        playerCardAttackLabel.layer.borderWidth = 1
        
        playerCardPictureLabel.text = "🥷"
        playerCardAttackLabel.text = "\(card.typeWarrior.attack)"
    }
}
