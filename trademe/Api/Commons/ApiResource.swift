//
//  ApiResource.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 14.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

protocol ApiResource {
    associatedtype Model
    
    var path: String { get } // e.g. /Categories/{number}.json
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: HttpMethod { get }
    
    func decodeModel(from jsonData: Data) throws -> Model
}

extension ApiResource {
    func decodeApiResource<Model: Codable>(from jsonData: Data) throws -> Model {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let model = try decoder.decode(Model.self, from: jsonData)
        return model
    }
}

extension ApiResource {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.tmsandbox.co.nz" // Sandbox environment!
        components.path = "/v1" + path
        components.queryItems = queryItems
        return components.url!
    }
}


