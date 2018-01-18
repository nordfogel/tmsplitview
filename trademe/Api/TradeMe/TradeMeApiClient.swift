//
//  TradeMeApi.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 16.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation
import UIKit

protocol TradeMeApiProtocol {
    func imageRequest(for url: URL, with completion: @escaping (UIImage) -> Void, failure: @escaping (Error?) -> Void) -> ImageRequest
    func listingRequest(for listingIdentifier: String, with completion: @escaping (Listing) -> Void, failure: @escaping (Error?) -> Void) -> ApiRequest<ListingApiResource>
    func categoryRequest(for categoryIdentifier: String, searchDepth: UInt?, with completion: @escaping (Category) -> Void, failure: @escaping (Error?) -> Void) -> ApiRequest<CategoryApiResource>
    func searchRequest(for categoryIdentifier: String, with completion: @escaping (SearchResult) -> Void, failure: @escaping (Error?) -> Void) -> ApiRequest<SearchApiResource>
    func searchKeyRequest(for searchKey: String, category categoryIdentifier: String, with completion: @escaping (SearchResult) -> Void, failure: @escaping (Error?) -> Void) -> ApiRequest<SearchKeyApiResource>
}


final class TradeMeApiClient: NSObject, TradeMeApiProtocol {
    
    private let urlSession: URLSession
    
    private static let consumerKey = "A1AC63F0332A131A78FAC304D007E7D1"
    private static let consumerSecret = "EC7F18B17A062962C6930A8AE88B16C7"
    private let defaultHeaders = [
        "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_signature_method=\"PLAINTEXT\", oauth_signature=\"\(consumerSecret)%26\"",
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept" : "application/json"
    ]
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        urlSession = URLSession(configuration: configuration)
        // let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func imageRequest(for url: URL, with completion: @escaping (UIImage) -> Void, failure: @escaping (Error?) -> Void) -> ImageRequest {
        let request = ImageRequest(url: url, urlSession: urlSession)
        request.load(with: completion, failure: failure)
        return request
    }
    
    func listingRequest(for listingIdentifier: String, with completion: @escaping (Listing) -> Void, failure: @escaping (Error?) -> Void) -> ApiRequest<ListingApiResource> {
        let resource = ListingApiResource(listingIdentifier: listingIdentifier)
        let request = ApiRequest(resource: resource, urlSession: urlSession)
        request.load(with: completion, failure: failure)
        return request
    }
    
    func categoryRequest(for categoryIdentifier: String, searchDepth: UInt? = nil, with completion: @escaping (Category) -> Void, failure: @escaping (Error?) -> Void) -> ApiRequest<CategoryApiResource> {
        let resource = CategoryApiResource(categoryIdentifier: categoryIdentifier, searchDepth: searchDepth)
        let request = ApiRequest(resource: resource, urlSession: urlSession)
        request.load(with: completion, failure: failure)
        return request
    }
    
    func searchRequest(for categoryIdentifier: String, with completion: @escaping (SearchResult) -> Void, failure: @escaping (Error?) -> Void) -> ApiRequest<SearchApiResource> {
        let resource = SearchApiResource(categoryIdentifier: categoryIdentifier)
        let request = ApiRequest(resource: resource, urlSession: urlSession)
        request.load(with: completion, failure: failure)
        return request
    }
    
    func searchKeyRequest(for searchKey: String, category categoryIdentifier: String, with completion: @escaping (SearchResult) -> Void, failure: @escaping (Error?) -> Void) -> ApiRequest<SearchKeyApiResource> {
        let resource = SearchKeyApiResource(searchString: searchKey, categoryIdentifier: categoryIdentifier)
        let request = ApiRequest(resource: resource, urlSession: urlSession)
        request.load(with: completion, failure: failure)
        return request
    }
}
