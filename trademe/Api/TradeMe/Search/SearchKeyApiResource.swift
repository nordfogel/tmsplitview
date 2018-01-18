//
//  SearchKeyApiResource.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 18.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct SearchKeyApiResource: ApiResource {
    let path = "/Search/General.json"
    let httpMethod: HttpMethod = .get
    
    
    private let searchString: String
    private let categoryIdentifier: String
    private let resultCount = 20
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "category", value: categoryIdentifier), URLQueryItem(name: "search_string", value: searchString), URLQueryItem(name: "rows", value: String(resultCount))]
    }
    
    init(searchString: String, categoryIdentifier: String) {
        self.searchString = searchString
        self.categoryIdentifier = categoryIdentifier
    }
    
    func decodeModel(from jsonData: Data) throws -> SearchResult {
        return try decodeApiResource(from: jsonData)
    }
}
