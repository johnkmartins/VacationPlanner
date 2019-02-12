//
//  BaseCollectionCell.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 11/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            setBackgroundColor(selected: isSelected)
        }
    }
    
    func setBackgroundColor(selected: Bool) {
        contentView.backgroundColor = selected ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 0.7580397725, green: 0.7857342958, blue: 0.8354353309, alpha: 1)
    }
}
