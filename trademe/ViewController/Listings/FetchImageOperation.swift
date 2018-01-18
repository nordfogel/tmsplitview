//
//  FetchImageOperation.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 17.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation
import UIKit

final class FetchImageOperation: Operation {
    let url: URL
    var completionHandler: ((UIImage?, Error?) -> ())?
    var image: UIImage?
    
    private let apiClient: TradeMeApiProtocol
    private var imageRequest: ImageRequest?
    
    init(url: URL, apiClient: TradeMeApiProtocol) {
        self.url = url
        self.apiClient = apiClient
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        imageRequest = apiClient.imageRequest(for: url, with: { [weak self] (image: UIImage?) in
            self?.image = image
            self?.completionHandler?(image, nil)
            }, failure: { [weak self] (error: Error?) in
                self?.completionHandler?(nil, error)
        })
    }
}
