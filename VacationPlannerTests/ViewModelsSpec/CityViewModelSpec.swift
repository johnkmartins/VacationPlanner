//
//  CityViewModelSpec.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 11/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Quick
import Nimble
@testable import VacationPlanner

class CityViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("When requesting for content") {
            context("With a internet connection") {
                var mockAPI: MockVacationPlannerAPI!
                var viewModel: CityViewModel!
                var errorMsg: String = ""
                
                beforeEach {
                    mockAPI = MockVacationPlannerAPI()
                    mockAPI.error = false
                    mockAPI.getCities() { result in
                        switch result {
                        case .success(let list):
                            viewModel = CityViewModel(model: list.first!)
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
                    expect(viewModel.country).to(equal("Brasil"))
                    expect(viewModel.description).to(equal("João Pessoa\nPB"))
                    expect(viewModel.district).to(equal("João Pessoa"))
                    expect(viewModel.province).to(equal("Paraiba"))
                    expect(viewModel.stateAcronym).to(equal("PB"))
                    expect(viewModel.woeId).to(equal("12345"))
                }
                
                it("Should not occur any errors") {
                    expect(errorMsg.isEmpty).to(beTrue())
                }
            }
            context("Ocurring error") {
                var mockAPI: MockVacationPlannerAPI!
                var viewModel: CityViewModel!
                var errorMsg: String = ""
                
                beforeEach {
                    mockAPI = MockVacationPlannerAPI()
                    mockAPI.error = true
                    mockAPI.getCities(){ result in
                        switch result {
                        case .success(let list):
                            viewModel = CityViewModel(model: list.first!)
                        case .error(let msg):
                            errorMsg = msg
                            break
                        }
                    }
                }
                
                it("Should occur error") {
                    expect(errorMsg).to(equal("Something wrong happened while loading the list of cities."))
                }
                
                it("Should have no view model") {
                    expect(viewModel).to(beNil())
                }
            }
        }
    }
}
