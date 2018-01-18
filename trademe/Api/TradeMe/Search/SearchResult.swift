//
//  SearchResult.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let totalCount: Int
    let listings: [Listing]
    
    enum CodingKeys : String, CodingKey {
        case totalCount = "TotalCount"
        case listings = "List"
    }
}
