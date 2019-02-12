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
    
    // MARK: - Private Atributes
    private let NUM_MAX_VACATION_DAYS: Int = 30
    private let NUM_MIN_VACATION_DAYS: Int = 1
    private let MAX_VALUE_YEAR: Int = 9999
    
    private var selectedWeathers: [WeatherViewModel] = [WeatherViewModel]()
    private var dailyClimateList: [DailyClimate]?
    private var selectedCity: CityViewModel?
    private var daysOfVacation: String = ""
    private var selectedYear: String = ""
    private var weatherList: [Weather]?
    private var cityList: [City]?
    private var apiPlanner: VacationPlannerAPI
    
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
    init(api: VacationPlannerAPI = VacationPlannerAPI()) {
        apiPlanner = api
    }
    
    // MARK: - Public Functions
    func getPlannerInfo() {
        getCities(nextStep: getWeathers)
    }
    
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
        let listClimateByDate = groupListOfDailyClimateByDate(from: getFilteredByWeatherDailyClimateList())
        
        let listOfStringsDate: [String] = listClimateByDate.compactMap { element in
            if let first = element.first, let last = element.last {
                return first.descriptionDate + " to " + last.descriptionDate
            }
            return nil
        }
        return listOfStringsDate.reduce("") { itemOne, itemTwo  in
            return itemOne + "\n" + "✅" + itemTwo + "\n"
        }
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
    
    func validateYear(_ year: String) -> Bool {
        selectedYear = year
        let currentYear = Calendar.current.component(.year, from: Date())
        if let intYear = Int(year) {
            return intYear >= currentYear && intYear <= MAX_VALUE_YEAR
        }
        return false
    }
    
    func validateDaysOfVacation(_ days: String) -> Bool {
        daysOfVacation = days
        if let intDays = Int(days) {
            return intDays > NUM_MIN_VACATION_DAYS && intDays <= NUM_MAX_VACATION_DAYS
        }
        return false
    }
    
    func validateEnteredInfo() {
        if let del = delegate {
            del.allInfoIs(ready: validateYear(selectedYear)
                && validateDaysOfVacation(daysOfVacation)
                && selectedCity != nil && !selectedWeathers.isEmpty)
        }
    }
    
    // MARK: - Private Functions
    private func getFilteredByWeatherDailyClimateList() -> [DailyClimateViewModel] {
        let mappedSelectedWeathers = selectedWeathers.map{ $0.name }
        return dailyClimateViewModelList.filter { mappedSelectedWeathers.contains($0.weather) }
    }
    
    private func groupListOfDailyClimateByDate(from list: [DailyClimateViewModel]) -> [[DailyClimateViewModel]] {
        
        guard let numDays = Int(daysOfVacation) else { return  [[DailyClimateViewModel]]() }
        var listOfGroups = [[DailyClimateViewModel]]()
        var group = [DailyClimateViewModel]()
        let last = list.count - 1
        
        for (i, dailyClimate) in list.enumerated() {
            if i+1 <= last, datesAreSequencial(firstDate: dailyClimate.date, secondDate: list[i+1].date) {
                group.isEmpty ? group.append(contentsOf: [dailyClimate, list[i+1]]) :  group.append(list[i+1])
            } else if group.count >= numDays {
                listOfGroups.append(group)
                group.removeAll()
            } else {
                group.removeAll()
            }
        }
        return listOfGroups
    }
    
    private func datesAreSequencial(firstDate: Date?, secondDate: Date?) -> Bool {
        guard let firstDt = firstDate, let secondDt = secondDate else { return false }
        return firstDt.isOneDayBefore(date: secondDt)
    }
    
    private func getCities(nextStep: @escaping (()->(Void)) = {}) {
        apiPlanner.getCities() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let listOfCities):
                self.cityList = listOfCities
                nextStep()
            case .error(let errorMsg):
                if let del = self.delegate { del.handleErrorWith(msg: errorMsg) }
            }
        }
    }
    
    private func getWeathers() {
       apiPlanner.getWeathers() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let listOfWeathers):
                self.weatherList = listOfWeathers
                if let del = self.delegate { del.updatePlannerData() }
            case .error(let errorMsg):
                if let del = self.delegate { del.handleErrorWith(msg: errorMsg) }
            }
        }
    }
}
