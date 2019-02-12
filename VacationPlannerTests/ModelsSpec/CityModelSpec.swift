//
//  CityAPIModelSpec.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Quick
import Nimble
@testable import VacationPlanner

class CityModelSpec: QuickSpec {
    override func spec() {
        context("When loading a Cities from a Json") {
            let model = JSONHelper.getObjectFrom(json: "cities", type: [City].self)
            
            it("Should not be nil") {
                expect(model).toNot(beNil())
            }
            
            it("Should match the number of elements in array") {
                expect(model?.count).to(equal(5))
            }
            
            it("Should match the expected attributes at first city") {
                expect(model?.first?.country).to(equal("Brazil"))
                expect(model?.first?.district).to(equal("Porto Alegre"))
                expect(model?.first?.province).to(equal("Rio Grande do Sul"))
                expect(model?.first?.stateAcronym).to(equal("RS"))
                expect(model?.first?.woeId).to(equal("455821"))
            }
            
            it("Should match the expected attributes at last city") {
                expect(model?.count).to(equal(5))
                expect(model?.last?.country).to(equal("Brazil"))
                expect(model?.last?.district).to(equal("Rio de Janeiro"))
                expect(model?.last?.province).to(equal("Rio de Janeiro"))
                expect(model?.last?.stateAcronym).to(equal("RJ"))
                expect(model?.last?.woeId).to(equal("455825"))
            }
        }
    }
}

