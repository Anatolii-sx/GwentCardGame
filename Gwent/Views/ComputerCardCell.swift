//
//  ComputerCardCell.swift
//  Gwent
//
//  Created by Анатолий Миронов on 10.12.2021.
//

import UIKit

class ComputerCardCell: UICollectionViewCell {
    // MARK: - IB Outlets
    @IBOutlet var computerCardPictureLabel: UILabel!
    @IBOutlet var computerCardAttackLabel: UILabel!
    
    // MARK: - Public Method
    func configureCell(cell: UICollectionViewCell, card: Card) {
        cell.layer.cornerRadius = 3
        cell.backgroundColor = .systemGray3
        
        computerCardPictureLabel.text = "🧟‍♂️"
        computerCardAttackLabel.text = "\(card.typeWarrior.attack)"
    }
}
