//
//  CitiesCollectionViewCell.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import UIKit

final class CityCollectionViewCell: BaseCollectionCell {
    
    @IBOutlet weak var cityDescriptionLabel: UILabel!
    
    func setup(viewModel: CityViewModel) {
        cityDescriptionLabel.text = viewModel.description
    }
}
