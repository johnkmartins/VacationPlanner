//
//  WeatherAPIModelSpec.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Quick
import Nimble
@testable import VacationPlanner

class WeatherModelSpec: QuickSpec {
    override func spec() {
        context("When loading a Weathers from a Json") {
            let model = JSONHelper.getObjectFrom(json: "weather", type: [Weather].self)
            
            it("Should not be nil") {
                expect(model).toNot(beNil())
            }
            
            it("Should match the number of elements in array") {
                expect(model?.count).to(equal(42))
            }
            
            it("Should match the expected attributes at first weather") {
                expect(model?.first?.name).to(equal("blowing snow"))
                expect(model?.first?.id).to(equal("001"))
            }
            
            it("Should match the expected attributes at last weather") {
                expect(model?.last?.name).to(equal("windy"))
                expect(model?.last?.id).to(equal("042"))
            }
        }
    }
}


