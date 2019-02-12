//
//  MockPlannerViewModelDelegate.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 11/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

@testable import VacationPlanner

final class MockPlannerViewModelDelegate: PlannerViewModelDelegate {
    
    var msgError = ""
    var plannerDataRecived = false
    var dailyClimateDataRecived = false
    var infosAreReady = false
    
    func handleErrorWith(msg: String) {
        msgError = msg
    }
    
    func onDailyClimatesReceived() {
        dailyClimateDataRecived = true
    }
    
    func updatePlannerData() {
        plannerDataRecived = true
    }
    
    func allInfoIs(ready: Bool) {
        infosAreReady = ready
    }
}
