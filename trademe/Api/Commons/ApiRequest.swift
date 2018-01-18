//
//  ApiRequest.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 14.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

class ApiRequest<Resource: ApiResource> {
    let resource: Resource
    let session: UrlSessionProtocol
    
    init(resource: Resource, urlSession: UrlSessionProtocol) {
        self.resource = resource
        self.session = urlSession
    }
}

extension ApiRequest: NetworkRequest {
    
    func decode(_ data: Data) throws -> Resource.Model {
        return try resource.decodeModel(from: data)
    }
    
    func load(with completion: @escaping (Resource.Model) -> Void, failure: @escaping (Error) -> Void) {
        load(resource.url, for: resource.httpMethod, with: completion, failure: failure)
    }
}
