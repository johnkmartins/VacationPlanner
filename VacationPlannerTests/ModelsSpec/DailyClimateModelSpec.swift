//
//  DailyClimateAPIModelSpec.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Quick
import Nimble
@testable import VacationPlanner

class DailyClimateModelSpec: QuickSpec {
    override func spec() {
        context("When loading a DailyClimates from a Json") {
            let model = JSONHelper.getObjectFrom(json: "dailyClimate", type: [DailyClimate].self)
            
            it("Should not be nil") {
                expect(model).toNot(beNil())
            }
            
            it("Should match the number of elements in array") {
                expect(model?.count).to(equal(5))
            }
            
            it("Should match the expected attributes at first dailyClimate") {
                expect(model?.first?.date).to(equal("2019-01-01"))
                expect(model?.first?.temperature?.max).to(equal(-8))
                expect(model?.first?.temperature?.min).to(equal(-10))
                expect(model?.first?.temperature?.unit).to(equal("C"))
                expect(model?.first?.weather).to(equal("mixed rain and hail"))
                expect(model?.first?.woeId).to(equal("455824"))
            }
            
            it("Should match the expected attributes at last dailyClimate") {
                expect(model?.last?.date).to(equal("2019-01-05"))
                expect(model?.last?.temperature?.max).to(equal(40))
                expect(model?.last?.temperature?.min).to(equal(-5))
                expect(model?.last?.temperature?.unit).to(equal("C"))
                expect(model?.last?.weather).to(equal("cloudy"))
                expect(model?.last?.woeId).to(equal("455824"))
            }
        }
    }
}


