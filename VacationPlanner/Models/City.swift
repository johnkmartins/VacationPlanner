//
//  City.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 07/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Foundation

struct City: Codable {
    var woeId: String?
    var district: String?
    var province: String?
    var stateAcronym: String?
    var country: String?
    
    enum CodingKeys: String, CodingKey {
        case woeId = "woeid"
        case district
        case province
        case stateAcronym = "state_acronym"
        case country
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        woeId = try values.decodeIfPresent(String.self, forKey: .woeId)
        district = try values.decodeIfPresent(String.self, forKey: .district)
        province = try values.decodeIfPresent(String.self, forKey: .province)
        stateAcronym = try values.decodeIfPresent(String.self, forKey: .stateAcronym)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }
    
    init(woeId: String, district: String, province: String, stateAcronym: String, country: String) {
        self.woeId = woeId
        self.district = district
        self.province = province
        self.stateAcronym = stateAcronym
        self.country = country
    }
}
