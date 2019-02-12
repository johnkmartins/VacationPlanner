//
//  DailyClimateViewModel.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Foundation

class DailyClimateViewModel {
    
    private var dailyClimate: DailyClimate
    
    init(model: DailyClimate) {
        dailyClimate = model
    }
    
    var woeId: String {
        return dailyClimate.woeId ?? ""
    }
    
    var dateString: String {
        return dailyClimate.date ?? ""
    }
    
    var weather: String {
        return dailyClimate.weather ?? ""
    }
    
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
    var descriptionDate: String {
        guard let dt = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: dt)
    }
    
    var maxTemperature: String {
        if let temp = dailyClimate.temperature, let max = temp.max {
            return String(max)
        }
        return ""
    }
    
    var minTemperature: String {
        if let temp = dailyClimate.temperature, let min = temp.min {
            return String(min)
        }
        return ""
    }
    
    var unitTemperature: String {
        if let temp = dailyClimate.temperature {
            return temp.unit ?? ""
        }
        return ""
    }
}
