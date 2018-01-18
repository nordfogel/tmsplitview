//
//  Photo.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let photoUrl: PhotoUrl
    
    enum CodingKeys : String, CodingKey {
        case id = "PhotoId"
        case photoUrl = "Value"
    }
}
