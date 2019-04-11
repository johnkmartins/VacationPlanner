//
//  Array+NextElement.swift
//  VacationPlanner
//
//  Created by John Martins on 11/04/19.
//  Copyright © 2019 John Kennedy Martins Alves. All rights reserved.
//

import UIKit

extension Array {
    func nextElementTo(_ index: Int) -> Element? {
        if index + 1 < count {
            return self[index + 1]
        }
        return nil
    }
}
