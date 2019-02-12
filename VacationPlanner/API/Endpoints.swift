//
//  Endpoints.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 08/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Foundation

enum Endpoints {
    case cities
    case weather
    case dailyClimate(woeId: String, year: String)
    
    var value: String {
        switch self {
        case .cities:
            return "cities/"
        case .weather:
            return "weather/"
        case .dailyClimate(let woeId, let year):
            return "cities/\(woeId)/year/\(year)"
        }
    }
    
    var errorMsg: String {
        switch self {
        case .cities:
            return "Something wrong happened while loading the list of cities."
        case .weather:
            return "Something wrong happened while loading the existing weather conditions."
        case .dailyClimate:
            return "Something wrong happened while trying to figure out the daily climates."
        }
    }
}
