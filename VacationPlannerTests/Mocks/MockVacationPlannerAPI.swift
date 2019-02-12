//
//  MockCityAPI.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 11/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import UIKit
@testable import VacationPlanner

final class MockVacationPlannerAPI: VacationPlannerAPI {
    
    var error: Bool = false
    
    override func getCities(completion: @escaping (Result<[City]>) -> (Void)) {
        let city = City(woeId: "12345", district: "João Pessoa", province: "Paraiba", stateAcronym: "PB", country: "Brasil")
        let cityTwo = City(woeId: "123456", district: "Triunfo", province: "Pernambuco", stateAcronym: "PE", country: "Brasil")
        let cities = [city, cityTwo]
        
        error ? completion(Result.error(Endpoints.cities.errorMsg)): completion(Result.success(cities))
    }
    
    override func getWeathers(completion: @escaping (Result<[Weather]>) -> (Void)) {
        let weatherOne = Weather(id: "12345", name: "Chuvoso")
        let weatherTwo = Weather(id: "123456", name: "Ensolarado")
        let listWeathers = [weatherOne, weatherTwo]
        
        error ? completion(Result.error(Endpoints.weather.errorMsg)): completion(Result.success(listWeathers))
    }
    
    override func getDailyClimates(year: String, woeId: String, completion: @escaping (Result<[DailyClimate]>) -> (Void)) {
        let climateOne = DailyClimate(date: "2019-04-23", temperature: Temperature(max: 30, min: 10, unit: "C"), weather: "Ensolarado", woeId: "123456")
        let climateTwo = DailyClimate(date: "2019-04-24", temperature: Temperature(max: 40, min: 20, unit: "C"), weather: "Ensolarado", woeId: "123456")
        let climateThree = DailyClimate(date: "2019-04-26", temperature: Temperature(max: 20, min: 0, unit: "C"), weather: "Chuvoso", woeId: "123456")
        
        let list = [climateOne, climateTwo, climateThree]
        
        error ? completion(Result.error(Endpoints.dailyClimate(woeId: woeId, year: year).errorMsg)):  completion(Result.success(list))
    }
}
