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
        computerCardAttackLabel.backgroundColor = .white
        computerCardAttackLabel.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
        computerCardAttackLabel.layer.borderWidth = 1
        
        computerCardPictureLabel.text = "🧟‍♂️"
        computerCardAttackLabel.text = "\(card.typeWarrior.attack)"
    }
}
