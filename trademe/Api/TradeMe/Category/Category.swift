//
//  Category.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct Category: Codable {
    let name: String
    let identifier: String
    let hierarchyPath: String?
    let subcategories: [Category]?
    let numberOfItemsForSale: Int?
    let isLeaf: Bool
    
    enum CodingKeys : String, CodingKey {
        case name = "Name"
        case identifier = "Number"
        case hierarchyPath = "Path"
        case subcategories = "Subcategories"
        case numberOfItemsForSale = "Count"
        case isLeaf = "IsLeaf"
    }
}
