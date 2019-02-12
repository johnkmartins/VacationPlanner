//
//  PlannerManager.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 12/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Foundation

class PlannerBusinessManager {
    
    private let NUM_MAX_VACATION_DAYS: Int = 30
    private let NUM_MIN_VACATION_DAYS: Int = 1
    private let MAX_VALUE_YEAR: Int = 9999
    
    func getDatesFormated(from list: [DailyClimateViewModel], with selectedDays: Int, selectedWeathers: [WeatherViewModel]) -> String {
        let listClimateByDate = groupListOfDailyClimateByDate(with: selectedDays, from: getFilteredByWeatherDailyClimateList(from: list, with: selectedWeathers))
        
        let listOfStringsDate = getListOfStringDates(from: listClimateByDate)
        
        return listOfStringsDate.reduce("") { itemOne, itemTwo  in
            return itemOne + "\n" + "✅" + itemTwo + "\n"
        }
    }
    
    func validate(year: String) -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        if let intYear = Int(year) {
            return intYear >= currentYear && intYear <= MAX_VALUE_YEAR
        }
        return false
    }
    
    func validate(days: String) -> Bool {
        if let intDays = Int(days) {
            return intDays > NUM_MIN_VACATION_DAYS && intDays <= NUM_MAX_VACATION_DAYS
        }
        return false
    }
    
    private func getListOfStringDates(from list: [[DailyClimateViewModel]]) -> [String] {
        return list.compactMap { element in
            if let first = element.first, let last = element.last {
                return first.descriptionDate + " to " + last.descriptionDate
            }
            return nil
        }
    }
    
    private func getFilteredByWeatherDailyClimateList(from list: [DailyClimateViewModel], with selectedWeathers: [WeatherViewModel]) -> [DailyClimateViewModel] {
        let mappedSelectedWeathers = selectedWeathers.map{ $0.name }
        return list.filter { mappedSelectedWeathers.contains($0.weather) }
    }
    
    private func groupListOfDailyClimateByDate(with daysOfVacation: Int, from list: [DailyClimateViewModel]) -> [[DailyClimateViewModel]] {
        
        var listOfGroups = [[DailyClimateViewModel]]()
        var group = [DailyClimateViewModel]()
        
        for (i, climate) in list.enumerated() {
            if i+1 <= list.count - 1, datesAreSequencial(first: climate.date, second: list[i+1].date) {
                group.isEmpty ? group.append(contentsOf: [climate, list[i+1]]) :  group.append(list[i+1])
            } else if group.count >= daysOfVacation {
                listOfGroups.append(group)
                group.removeAll()
            } else {
                group.removeAll()
            }
        }
        return listOfGroups
    }
    
    private func datesAreSequencial(first: Date?, second: Date?) -> Bool {
        guard let firstDt = first, let secondDt = second else { return false }
        return firstDt.isOneDayBefore(date: secondDt)
    }
}
