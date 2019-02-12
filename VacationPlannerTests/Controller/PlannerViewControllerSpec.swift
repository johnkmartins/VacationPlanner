//
//  PlannerViewControllerSpec.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 12/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import Quick
import Nimble
import UIKit
@testable import VacationPlanner

class PlannerViewControllerSpec: QuickSpec {
    
    override func spec() {
        describe("Testing ViewController") {
            
            context("When receive the right data") {
                let mockAPI = MockVacationPlannerAPI()
                mockAPI.error = false
                let viewModel = PlannerViewModel(api: mockAPI)
                var plannerController: PlannerViewController!
                
                beforeEach {
                    viewModel.getPlannerInfo()
                }
                
                it("Testing data in collections") {
                    guard let firstOfMainViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PlannerViewController") as? PlannerViewController else { return }
                    plannerController = firstOfMainViewController
                    
                    plannerController.viewModel = viewModel
                    
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    
                    let collectionViewCity = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
                    let collectionViewWeather = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
                    
                    plannerController.citiesCollectionView = collectionViewCity
                    plannerController.weatherCollectionView = collectionViewWeather
                    
                    collectionViewCity.dataSource = plannerController
                    collectionViewWeather.dataSource = plannerController
                    
                    plannerController.citiesCollectionView.reloadData()
                    plannerController.weatherCollectionView.reloadData()
                    expect(plannerController.citiesCollectionView.numberOfSections).to(equal(1))
                    expect(plannerController.weatherCollectionView.numberOfSections).to(equal(1))
                    expect(plannerController.citiesCollectionView.numberOfItems(inSection: 0)).to(equal(2))
                    expect(plannerController.weatherCollectionView.numberOfItems(inSection: 0)).to(equal(2))
                }
            }
        }
    }
}
