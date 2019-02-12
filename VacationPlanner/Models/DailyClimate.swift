//
//  DailyClimate.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 07/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Foundation

struct DailyClimate: Codable {
    var date: String?
    var temperature: Temperature?
    var weather: String?
    var woeId: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case temperature
        case weather
        case woeId = "woeid"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        temperature = try values.decodeIfPresent(Temperature.self, forKey: .temperature)
        weather = try values.decodeIfPresent(String.self, forKey: .weather)
        woeId = try values.decodeIfPresent(String.self, forKey: .woeId)
    }
    
    init(date: String, temperature: Temperature, weather: String, woeId: String) {
        self.date = date
        self.temperature = temperature
        self.weather = weather
        self.woeId = woeId
    }
}
