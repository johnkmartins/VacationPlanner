//
//  JSONHelper.swift
//  VacationPlannerTests
//
//  Created by John Kennedy Martins Alves on 09/02/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import UIKit

class JSONHelper {
    
    class func getDictionaryFrom(json file: String) -> [AnyHashable: Any]? {
        if let path = Bundle(for: JSONHelper.self).path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonDictionary = jsonResult as? [AnyHashable: Any] {
                    return jsonDictionary
                }
            } catch {
                fatalError("Wrong Format JSON")
            }
        }
        fatalError("Wrong Format JSON")
    }
    
    class func getArrayFrom(json file: String) -> [[AnyHashable: Any]?] {
        if let path = Bundle(for: JSONHelper.self).path(forResource: file, ofType: "json") {
            print(path)
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonArray = jsonResult as? [[AnyHashable: Any]] {
                    return jsonArray
                }
            } catch {
                fatalError("Wrong Format JSON")
            }
        }
        fatalError("Wrong Format JSON")
    }
    
    class func getStringDitionaryFrom(json file: String) -> [String: Any]? {
        if let path = Bundle(for: JSONHelper.self).path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonDictionary = jsonResult as? [String: Any] {
                    return jsonDictionary
                }
            } catch {
                fatalError("Wrong Format JSON")
            }
        }
        fatalError("Wrong Format JSON")
    }
    
    class func getDataFrom(json file: String) -> Data? {
        if let path = Bundle(for: JSONHelper.self).path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                fatalError("Wrong Format JSON")
            }
        }
        fatalError("Wrong Format JSON")
    }
    
    class func getObjectFrom<T: Codable>(json file: String, type: T.Type) -> T? {
        guard let jsonData = getDataFrom(json: file) else { return nil }
        if let objDecoded = try? JSONDecoder().decode(T.self, from: jsonData) {
            return objDecoded
        }
        return nil
    }
}
