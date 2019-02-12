//
//  ClimatesCollectionViewCell.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import UIKit

final class WeatherCollectionViewCell: BaseCollectionCell {
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    func setup(viewModel: WeatherViewModel) {
        weatherDescriptionLabel.text = viewModel.description
    }
}
