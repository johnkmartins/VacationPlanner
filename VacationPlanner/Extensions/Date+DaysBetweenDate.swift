//
//  Date+DaysBetweenDate.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 10/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//
import UIKit

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    
    func isOneDayBefore(date: Date) -> Bool {
        return daysBetweenDate(toDate: date) == 1
    }
}
