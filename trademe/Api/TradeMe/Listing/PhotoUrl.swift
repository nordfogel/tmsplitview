//
//  PhotoUrl.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

struct PhotoUrl: Codable {
    let thumbnail: URL
    
    enum CodingKeys : String, CodingKey {
        case thumbnail = "Thumbnail"
    }
}
