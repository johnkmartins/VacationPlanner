//
//  WeatherViewModelSpec.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 11/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Quick
import Nimble
@testable import VacationPlanner

class WeatherViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("When requesting for content") {
            context("With a internet connection") {
                var mockAPI: MockVacationPlannerAPI!
                var viewModel: WeatherViewModel!
                var errorMsg: String = ""
                
                beforeEach {
                    mockAPI = MockVacationPlannerAPI()
                    mockAPI.error = false
                    mockAPI.getWeathers() { result in
                        switch result {
                        case .success(let list):
                            viewModel = WeatherViewModel(model: list.first!)
                        case .error(let msg):
                            errorMsg = msg
                            break
                        }
                    }
                }
                
                it("Should notify the received weather") {
                    expect(viewModel).toNot(beNil())
                }
                
                it("Should update atributes from VM") {
                    expect(viewModel.description).to(equal("CHUVOSO"))
                    expect(viewModel.name).to(equal("Chuvoso"))
                    expect(viewModel.id).to(equal("12345"))
                }
                
                it("Should not occur any errors") {
                    expect(errorMsg.isEmpty).to(beTrue())
                }
            }
            context("Ocurring error") {
                var mockAPI: MockVacationPlannerAPI!
                var viewModel: WeatherViewModel!
                var errorMsg: String = ""
                
                beforeEach {
                    mockAPI = MockVacationPlannerAPI()
                    mockAPI.error = true
                    mockAPI.getWeathers() { result in
                        switch result {
                        case .success(let list):
                            viewModel = WeatherViewModel(model: list.first!)
                        case .error(let msg):
                            errorMsg = msg
                            break
                        }
                    }
                }
                
                it("Should occur error") {
                    expect(errorMsg).to(equal("Something wrong happened while loading the existing weather conditions."))
                }
                
                it("Should have no view model") {
                    expect(viewModel).to(beNil())
                }
            }
        }
    }
}

