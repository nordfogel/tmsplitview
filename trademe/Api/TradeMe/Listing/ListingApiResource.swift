//
//  ListingApiResource.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct ListingApiResource: ApiResource {
    let httpMethod: HttpMethod = .get
    
    private let listingIdentifier: String
    var path: String {
        return "/Listings/\(listingIdentifier).json"
    }
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    init(listingIdentifier: String) {
        self.listingIdentifier = listingIdentifier
    }
    
    func decodeModel(from jsonData: Data) throws -> Listing {
        return try decodeApiResource(from: jsonData)
    }
}
