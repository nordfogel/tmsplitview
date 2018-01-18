//
//  CategoryApiResource.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct CategoryApiResource: ApiResource {
    
    private let categoryIdentifier: String
    private var searchDepth: UInt?
    
    let httpMethod: HttpMethod = .get
    
    var path: String {
        return "/Categories/\(categoryIdentifier).json"
    }
    
    var queryItems: [URLQueryItem]? {
        var queryItems = [URLQueryItem(name: "with_counts", value: "true")]
        if let depth = searchDepth {
            queryItems.append(URLQueryItem(name: "depth", value: String(depth)))
        }
        return queryItems
    }
    
    init(categoryIdentifier: String, searchDepth: UInt? = nil) {
        self.categoryIdentifier = categoryIdentifier
        self.searchDepth = searchDepth
    }
    
    func decodeModel(from jsonData: Data) throws -> Category {
        return try decodeApiResource(from: jsonData)
    }
}



