//
//  Listing.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct Listing: Codable {
    let id: Int
    let photos: [Photo]?
    let imageUrl: URL?
    let title: String
    let category: String
    let endDate: String
    
    enum CodingKeys : String, CodingKey {
        case id = "ListingId"
        case photos = "Value"
        case imageUrl = "PictureHref"
        case title = "Title"
        case category = "Category"
        case endDate = "EndDate"
    }
}

extension Listing {
    var primaryThumbUrl: URL? {
        if let thumbUrl = photos?.first?.photoUrl.thumbnail {
            return thumbUrl
        }
        return imageUrl
    }
}
