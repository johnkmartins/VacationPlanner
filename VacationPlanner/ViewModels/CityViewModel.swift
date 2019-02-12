//
//  CityViewModel.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Foundation

class CityViewModel {
    
    private var city: City
    
    init(model: City) {
        city = model
    }
    
    var woeId: String {
        return city.woeId ?? ""
    }
    
    var district: String {
        return city.district ?? ""
    }
    
    var province: String {
        return city.province ?? ""
    }
    
    var stateAcronym: String {
        return city.stateAcronym ?? ""
    }
    
    var country: String {
        return city.country ?? ""
    }
    
    var description: String {
        return district + "\n" + stateAcronym
    }
}
