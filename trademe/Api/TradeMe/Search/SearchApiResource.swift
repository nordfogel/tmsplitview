//
//  SearchApiResource.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct SearchApiResource: ApiResource {
    let path = "/Search/General.json"
    let httpMethod: HttpMethod = .get
    
    private let categoryIdentifier: String
    private let resultCount = 20
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "category", value: categoryIdentifier), URLQueryItem(name: "rows", value: String(resultCount))]
    }
    
    init(categoryIdentifier: String) {
        self.categoryIdentifier = categoryIdentifier
    }
    
    func decodeModel(from jsonData: Data) throws -> SearchResult {
        return try decodeApiResource(from: jsonData)
    }
}
