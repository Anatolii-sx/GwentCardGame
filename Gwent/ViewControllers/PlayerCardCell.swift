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
        
        playerCardPictureLabel.text = "🥷"
        playerCardAttackLabel.text = "\(card.typeWarrior.attack)"
    }
}
