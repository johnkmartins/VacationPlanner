//
//  DailyClimateViewModelSpec.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 10/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Quick
import Nimble
@testable import VacationPlanner

class DailyClimateViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("When requesting for content") {
            context("With a internet connection") {
                var mockAPI: MockVacationPlannerAPI!
                var viewModel: DailyClimateViewModel!
                var errorMsg: String = ""
                
                beforeEach {
                    mockAPI = MockVacationPlannerAPI()
                    mockAPI.error = false
                    mockAPI.getDailyClimates(year: "", woeId: "") { result in
                        switch result {
                        case .success(let list):
                            viewModel = DailyClimateViewModel(model: list.first!)
                        case .error(let msg):
                            errorMsg = msg
                            break
                        }
                    }
                }
                
                it("Should notify the received dailyClimate") {
                    expect(viewModel).toNot(beNil())
                }
                
                it("Should update atributes from VM") {
                    expect(viewModel.dateString).to(equal("2019-04-23"))
                    expect(viewModel.descriptionDate).to(equal("Apr 23, 2019"))
                    expect(viewModel.maxTemperature).to(equal("30"))
                    expect(viewModel.minTemperature).to(equal("10"))
                    expect(viewModel.weather).to(equal("Ensolarado"))
                    expect(viewModel.woeId).to(equal("123456"))
                    expect(viewModel.unitTemperature).to(equal("C"))
                    expect(viewModel.date).toNot(beNil())
                }
                
                it("Should not occur any errors") {
                    expect(errorMsg.isEmpty).to(beTrue())
                }
            }
            context("Ocurring error") {
                var mockAPI: MockVacationPlannerAPI!
                var viewModel: DailyClimateViewModel!
                var errorMsg: String = ""
                
                beforeEach {
                    mockAPI = MockVacationPlannerAPI()
                    mockAPI.error = true
                    mockAPI.getDailyClimates(year: "", woeId: "") { result in
                        switch result {
                        case .success(let list):
                            viewModel = DailyClimateViewModel(model: list.first!)
                        case .error(let msg):
                            errorMsg = msg
                            break
                        }
                    }
                }

                it("Should occur error") {
                    expect(errorMsg).to(equal("Something wrong happened while trying to figure out the daily climates."))
                }

                it("Should have no view model") {
                    expect(viewModel).to(beNil())
                }
            }
        }
    }
}

