//
//  WeatherViewModel.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Foundation

class WeatherViewModel {
    
    private var weather: Weather
    
    init(model: Weather) {
        weather = model
    }
    
    var id: String {
        return weather.id ?? ""
    }
    
    var name: String {
        return weather.name ?? ""
    }
    
    var description: String {
        return name.uppercased()
    }
}
