//
//  NetworkRequest.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 14.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

protocol UrlSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: UrlSessionProtocol {}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkRequestError: Error {
    case invalidData
    case objectHasBeenRemoved
}

protocol NetworkRequest: class {
    associatedtype Model
    
    var session: UrlSessionProtocol { get }
    
    func load(with completion: @escaping (Model) -> Void, failure: @escaping (Error) -> Void)
    func decode(_ data: Data) throws -> Model
}

extension NetworkRequest {
    func load(_ url: URL, for httpMethod: HttpMethod, with completion: @escaping (Model) -> Void, failure: @escaping (Error) -> Void) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        let task = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            
            print(response.debugDescription)
            
            if let error = error {
                failure(error)
            } else if let jsonData = data {

                guard let strongSelf = self else {
                    failure(NetworkRequestError.objectHasBeenRemoved)
                    return
                }
                
                do {
                    let model = try strongSelf.decode(jsonData)
                    completion(model)
                } catch (let error) {
                    failure(error)
                }
            } else {
                failure(NetworkRequestError.invalidData)
            }
        }
        task.resume()
    }
}
