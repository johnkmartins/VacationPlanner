//
//  PlannerViewModel.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Foundation

protocol PlannerViewModelDelegate: class {
    func handleErrorWith(msg: String)
    func onDailyClimatesReceived()
    func updatePlannerData()
    func allInfoIs(ready: Bool)
}

class PlannerViewModel {
    
    private let TIMEOUT_SECONDS = 10
    private let ERROR_MSG = "Um Erro aconteceu ao recuperar os dados"
    
    private var selectedWeathers: [WeatherViewModel] = [WeatherViewModel]()
    private var dailyClimateList: [DailyClimate]?
    private var selectedCity: CityViewModel?
    private var daysOfVacation: String = ""
    private var selectedYear: String = ""
    private var weatherList: [Weather]?
    private var cityList: [City]?
    private var apiPlanner: VacationPlannerAPI
    private var managerPlannerBusiness: PlannerBusinessManager
    private var errorGetCities = false
    private var errorGetWeathers = false
    
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Public Atributes
    weak var delegate: PlannerViewModelDelegate?
    
    var cityViewModelList: [CityViewModel] {
        guard let list = cityList else { return [CityViewModel]() }
        return list.map { CityViewModel(model: $0) }
    }
    
    var weartherViewModelList: [WeatherViewModel] {
        guard let list = weatherList else { return [WeatherViewModel]() }
        return list.map { WeatherViewModel(model: $0) }
    }
    
    var dailyClimateViewModelList: [DailyClimateViewModel] {
        guard let list = dailyClimateList else { return [DailyClimateViewModel]() }
        return list.map { DailyClimateViewModel(model: $0) }
    }
    
    //MARK: - Init
    init(api: VacationPlannerAPI = VacationPlannerAPI(), manager: PlannerBusinessManager = PlannerBusinessManager()) {
        apiPlanner = api
        managerPlannerBusiness = manager
    }
    
    // MARK: - Public Functions
    func addSelectedWeather(from index: Int) {
        selectedWeathers.append(weartherViewModelList[index])
    }
    
    func changeSelectedCity(from index: Int) {
        selectedCity = cityViewModelList[index]
    }
    
    func removeSelectedWeather(from index: Int) {
        selectedWeathers = selectedWeathers.filter { $0.id != weartherViewModelList[index].id }
    }
    
    func getVacationDatesFormated() -> String {
        guard let days = Int(daysOfVacation) else { return ""}
        
        return managerPlannerBusiness.getDatesFormated(from: dailyClimateViewModelList, with: days, selectedWeathers: selectedWeathers)
    }
    
    func validateYear(_ year: String) -> Bool {
        selectedYear = year
        return managerPlannerBusiness.validate(year: year)
    }
    
    func validateDaysOfVacation(_ days: String) -> Bool {
        daysOfVacation = days
        return managerPlannerBusiness.validate(days: days)
    }
    
    func validateEnteredInfo() {
        if let del = delegate {
            del.allInfoIs(ready: validateYear(selectedYear)
                && validateDaysOfVacation(daysOfVacation)
                && selectedCity != nil && !selectedWeathers.isEmpty)
        }
    }
    
    func getPlannerInfo() {
        getCities()
        getWeathers()
        handleDispatchGroup()
    }
    
    func getDailyClimates() {
        guard let cityVM = selectedCity, !selectedYear.isEmpty else { return }
        
        apiPlanner.getDailyClimates(year: selectedYear, woeId: cityVM.woeId) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let listDailyClimate):
                self.dailyClimateList = listDailyClimate
                if let del = self.delegate { del.onDailyClimatesReceived() }
            case .error(let errorMsg):
                if let del = self.delegate { del.handleErrorWith(msg: errorMsg) }
            }
        }
    }
    
    // MARK: - Private Functions
    private func getCities() {
        dispatchGroup.enter()
        apiPlanner.getCities() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let listOfCities):
                self.cityList = listOfCities
                self.errorGetCities = false
            case .error(_):
                self.errorGetCities = true
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getWeathers() {
        dispatchGroup.enter()
        apiPlanner.getWeathers() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let listOfWeathers):
                self.weatherList = listOfWeathers
                self.errorGetWeathers = false
            case .error(_):
               self.errorGetWeathers = true
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func handleDispatchGroup() {
        let timeout = DispatchTime.now() + .seconds(TIMEOUT_SECONDS)
        
        if dispatchGroup.wait(timeout: timeout) == .timedOut {
            delegate?.handleErrorWith(msg: ERROR_MSG)
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            if self.errorGetCities || self.errorGetWeathers {
                self.delegate?.handleErrorWith(msg: self.ERROR_MSG)
            } else {
                self.delegate?.updatePlannerData()
            }
        }
    }
}
