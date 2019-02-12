//
//  VacationPlannerAPI.swift
//  VacationPlanner
//
//  Created by John Kennedy Martins Alves on 08/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import UIKit

enum Result<T> {
    case success(T)
    case error(String)
}

class VacationPlannerAPI {
    
    private let urlString = "http://localhost:8882/"
    
    func getCities(completion: @escaping (Result<[City]>) -> (Void)) {
        requestObjectWith(endpoint: .cities, completion: completion)
    }
    
    func getWeathers(completion: @escaping (Result<[Weather]>) -> (Void)) {
        requestObjectWith(endpoint: .weather, completion: completion)
    }
    
    func getDailyClimates(year: String, woeId: String, completion: @escaping (Result<[DailyClimate]>) -> (Void)) {
        requestObjectWith(endpoint: Endpoints.dailyClimate(woeId: woeId, year: year), completion: completion)
    }
    
    private func requestObjectWith<T: Codable>(endpoint: Endpoints, completion: @escaping (Result<T>) -> (Void)) {
        guard let url = URL(string: urlString + endpoint.value) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let remoteDataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let receivedData = data {
                do {
                    let objectResponse = try JSONDecoder().decode(T.self, from: receivedData)
                    completion(.success(objectResponse))
                } catch {
                    completion(.error(endpoint.errorMsg))
                }
            } else {
                completion(.error(endpoint.errorMsg))
            }
        }
        remoteDataTask.resume()
    }
}


