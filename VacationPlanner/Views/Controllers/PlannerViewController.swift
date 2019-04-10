//
//  ViewController.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 07/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import UIKit

class PlannerViewController: UIViewController {
    
    // MARK: - Private Atributes
    private let CITY_COLLECTION_CELL_ID: String = "CityCollectionViewCell"
    private let WEATHER_COLLECTION_CELL_ID: String = "WeatherCollectionViewCell"
    
    var viewModel: PlannerViewModel = PlannerViewModel()
    
    // MARK: - Outlets
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var numberOfDaysTextField: UITextField!
    @IBOutlet weak var citiesCollectionView: UICollectionView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var messageWrongDataDays: UILabel!
    @IBOutlet weak var messageWrongDataYear: UILabel!
    @IBOutlet weak var searchResultsButton: UIButton!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getPlannerInfo()
        setupCollections()
        setupTextFields()
        setupButton()
    }
    
    // MARK: - Actions
    @IBAction func onSearchClicked(_ sender: Any) {
        showLoading(true)
        viewModel.getDailyClimates()
    }
    
    @objc func daysTextFieldDidChange(textField: UITextField) {
        let isValid = viewModel.validateDaysOfVacation(textField.text ?? "")
        messageWrongDataDays.alpha = isValid ? 0 : 1
        viewModel.validateEnteredInfo()
    }
    
    @objc func yearTextFieldDidChange(textField: UITextField) {
        let isValid = viewModel.validateYear(textField.text ?? "")
        messageWrongDataYear.alpha = isValid ? 0 : 1
        viewModel.validateEnteredInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Private Functions
    private func setupCollections() {
        citiesCollectionView.delegate = self
        citiesCollectionView.dataSource = self
        citiesCollectionView.accessibilityIdentifier = "CollectionCity"
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        weatherCollectionView.allowsMultipleSelection = true
        weatherCollectionView.accessibilityIdentifier = "CollectionWeather"
    }
    
    private func setupTextFields() {
        numberOfDaysTextField.addTarget(self, action: #selector(daysTextFieldDidChange), for: .editingChanged)
        
        yearTextField.addTarget(self, action: #selector(yearTextFieldDidChange), for: .editingChanged)
    }
    
    private func setupButton() {
        searchResultsButton.alpha = 0.5
        searchResultsButton.isEnabled = false
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.citiesCollectionView.reloadData()
            self.weatherCollectionView.reloadData()
        }
    }
    
    private func handlerTryAgain(alert: UIAlertAction!) {
        viewModel.getPlannerInfo()
    }
    
    private func showAlertWith(title: String, msg: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tente novamente", style: .default, handler: self.handlerTryAgain))
            self.present(alert, animated: true)
        }
    }
    
    private func showLoading(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewLoading.isHidden = !show
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
}
extension PlannerViewController: PlannerViewModelDelegate {
    
    func allInfoIs(ready: Bool) {
        searchResultsButton.alpha = ready ? 1.0 : 0.5
        searchResultsButton.isEnabled = ready
    }
    
    func onDailyClimatesReceived() {
        showLoading(false)
        let dates = viewModel.getVacationDatesFormated()
        dates.isEmpty ? showAlertWith(title: "Oops 😕", msg: "Sorry, we don't find any results for your search.") : showAlertWith(title: "Let's travel 😀 ✈️ 🚎 🛳", msg: dates)
    }
    
    func updatePlannerData() {
        showLoading(false)
        reloadData()
    }
    
    func handleErrorWith(msg: String) {
        showLoading(false)
        showAlertWith(title: "Oops 😣", msg: msg)
    }
}

extension PlannerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == citiesCollectionView ? viewModel.cityViewModelList.count :  viewModel.weartherViewModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == citiesCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CITY_COLLECTION_CELL_ID, for: indexPath) as? CityCollectionViewCell {
            cell.setup(viewModel: viewModel.cityViewModelList[indexPath.row])
            return cell
            
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WEATHER_COLLECTION_CELL_ID, for: indexPath) as? WeatherCollectionViewCell {
            cell.setup(viewModel: viewModel.weartherViewModelList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView == weatherCollectionView ? viewModel.addSelectedWeather(from: indexPath.row) : viewModel.changeSelectedCity(from: indexPath.row)
        viewModel.validateEnteredInfo()
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == weatherCollectionView {
            viewModel.removeSelectedWeather(from: indexPath.row)
        }
        viewModel.validateEnteredInfo()
    }
}

