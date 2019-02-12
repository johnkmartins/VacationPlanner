//
//  PlannerViewModelSpec.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 11/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Quick
import Nimble
@testable import VacationPlanner

class PlannerViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("Loading Planner View Model") {
            context("Calling the API for initial data with internet connection") {
                let mockAPI = MockVacationPlannerAPI()
                mockAPI.error = false
                let mockDelegate = MockPlannerViewModelDelegate()
                let viewModel = PlannerViewModel(api: mockAPI)
                viewModel.delegate = mockDelegate
                
                beforeEach {
                    viewModel.getPlannerInfo()
                }
                
                it("Should not occur error") {
                    expect(mockDelegate.msgError).to(equal(""))
                }
                
                it("Should update atributes from VM") {
                    expect(viewModel.cityViewModelList.count).to(equal(2))
                    expect(viewModel.weartherViewModelList.count).to(equal(2))
                    expect(viewModel.dailyClimateViewModelList.count).to(equal(0))
                }
                
                it("Should call correct delegate func") {
                    expect(mockDelegate.plannerDataRecived).to(beTrue())
                    expect(mockDelegate.dailyClimateDataRecived).to(beFalse())
                    expect(mockDelegate.infosAreReady).to(beFalse())
                }
            }
            context("Calling the API for initial data and ocurring error") {
                let mockAPI = MockVacationPlannerAPI()
                mockAPI.error = true
                let mockDelegate = MockPlannerViewModelDelegate()
                let viewModel = PlannerViewModel(api: mockAPI)
                viewModel.delegate = mockDelegate
                
                beforeEach {
                    viewModel.getPlannerInfo()
                }
                
                it("Should occur error") {
                    expect(mockDelegate.msgError).to(equal("Something wrong happened while loading the list of cities."))
                }
                
                it("Should have no data at view model") {
                    expect(viewModel.cityViewModelList.count).to(equal(0))
                    expect(viewModel.weartherViewModelList.count).to(equal(0))
                    expect(viewModel.dailyClimateViewModelList.count).to(equal(0))
                }
            }
            context("Calling the API for Daily Climates with right info") {
                let mockAPI = MockVacationPlannerAPI()
                mockAPI.error = false
                let mockDelegate = MockPlannerViewModelDelegate()
                let viewModel = PlannerViewModel(api: mockAPI)
                viewModel.delegate = mockDelegate
                var validateYear: Bool!
                var validateDays: Bool!
                var resultDatas: String!
                
                beforeEach {
                    viewModel.getPlannerInfo()
                    viewModel.changeSelectedCity(from: 0)
                    viewModel.addSelectedWeather(from: 0)
                    viewModel.addSelectedWeather(from: 1)
                    validateYear = viewModel.validateYear("2019")
                    validateDays = viewModel.validateDaysOfVacation("2")
                    viewModel.validateEnteredInfo()
                    viewModel.getDailyClimates()
                    resultDatas = viewModel.getVacationDatesFormated()
                }
                
                it("Should validate year correctly") {
                    expect(validateYear).to(beTrue())
                }
                
                it("Should validade days of vacation correctly") {
                    expect(validateDays).to(beTrue())
                }
                
                it("Should validate info correctly") {
                    expect(mockDelegate.infosAreReady).to(beTrue())
                }
                
                it("Should update the list of Daily climates") {
                    expect(viewModel.dailyClimateViewModelList.count).to(equal(3))
                    expect(mockDelegate.dailyClimateDataRecived).to(beTrue())
                }
                
                it("Should get the right list of datas") {
                    expect(resultDatas.isEmpty).to(beFalse())
                    expect(resultDatas).to(equal("\n✅Apr 23, 2019 to Apr 24, 2019\n"))
                }
            }
            context("Calling the API for Daily Climates with the wrong info") {
                let mockAPI = MockVacationPlannerAPI()
                mockAPI.error = false
                let mockDelegate = MockPlannerViewModelDelegate()
                let viewModel = PlannerViewModel(api: mockAPI)
                viewModel.delegate = mockDelegate
                var validateYear: Bool!
                var validateDays: Bool!
                var resultDatas: String!
                
                beforeEach {
                    viewModel.getPlannerInfo()
                    viewModel.changeSelectedCity(from: 0)
                    viewModel.addSelectedWeather(from: 0)
                    viewModel.addSelectedWeather(from: 1)
                    validateYear = viewModel.validateYear("2010")
                    validateDays = viewModel.validateDaysOfVacation("1")
                    viewModel.validateEnteredInfo()
                    resultDatas = viewModel.getVacationDatesFormated()
                }
                
                it("Should validate year correctly") {
                    expect(validateYear).to(beFalse())
                }
                
                it("Should validade days of vacation correctly") {
                    expect(validateDays).to(beFalse())
                }
                
                it("Should validate info correctly") {
                    expect(mockDelegate.infosAreReady).to(beFalse())
                }
                
                it("Should update the list of Daily climates") {
                    expect(viewModel.dailyClimateViewModelList.count).to(equal(0))
                }
                
                it("Should get the right list of datas") {
                    expect(resultDatas.isEmpty).to(beTrue())
                }
            }
        }
    }
}
