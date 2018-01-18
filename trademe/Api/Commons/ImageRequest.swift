//
//  ImageRequest.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 14.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation
import UIKit

enum ImageRequestError: Error {
    case invalidImageData
}

final class ImageRequest {
    let url: URL
    let session: UrlSessionProtocol

    init(url: URL, urlSession: UrlSessionProtocol) {
        self.url = url
        self.session = urlSession
    }
}

extension ImageRequest: NetworkRequest {

    func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkRequestError.invalidData
        }
        return image
    }

    func load(with completion: @escaping (UIImage) -> Void, failure: @escaping (Error) -> Void) {
        load(url, for: HttpMethod.get, with: completion, failure: failure)
    }
}
