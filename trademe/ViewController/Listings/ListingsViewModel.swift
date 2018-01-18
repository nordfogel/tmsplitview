//
//  ListingsViewModel.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 16.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation
import UIKit

protocol SearchRequestViewModelProtocol {
    func fetchListings(for searchString: String, in category: String)
    func imageCompletion(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void)
}

typealias ListingsViewModelProtocol = ListViewModelProtocol & SearchRequestViewModelProtocol



final class ListingsViewModel: ListingsViewModelProtocol {
    
    var title: String {
        return "Listings"
    }
    
    private let fetchImageQueue = OperationQueue()
    private (set) var fetchImageOperations = [IndexPath: FetchImageOperation]()
    
    var itemCount: Int {
        return cellViewModels.count
    }
    
    var updateLoadingState: ((Bool)->Void)?
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingState?(isLoading)
        }
    }
    
    private var request: AnyObject?
    
    var errorClosure: ((String, String)->Void)?
    var reloadClosure: (()->Void)?
    private var cellViewModels = [ListItemCellViewModelProtocol]() {
        didSet {
            self.reloadClosure?()
        }
    }
    
    private let apiClient: TradeMeApiProtocol
    
    init(apiClient: TradeMeApiProtocol) {
        self.apiClient = apiClient
    }
    
    func imageCompletion(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        guard indexPath.row >= 0 && indexPath.row < itemCount else {
            return
        }
        
        if let fetchImageOperation = fetchImageOperations[indexPath], let image = fetchImageOperation.image {
            completion(image)
        } else if let url = cellViewModel(at: indexPath.row)?.thumbUrl, fetchImageOperations[indexPath] == nil {
            let fetchImageOperation = FetchImageOperation(url: url, apiClient: apiClient)
            fetchImageOperation.completionHandler = { (image, error) in
                if let image = image {
                    completion(image)
                }
            }
            fetchImageQueue.addOperation(fetchImageOperation)
            fetchImageOperations[indexPath] = fetchImageOperation
        } else {
            completion(UIImage(named: "placeholder"))
        }
    }
    
    func cellViewModel(at index: Int) -> ListItemCellViewModelProtocol? {
        guard index >= 0 && index < itemCount else {
            return nil
        }
        return cellViewModels[index]
    }
    
    func fetchListings(for searchString: String, in category: String) {
        self.fetchImageQueue.cancelAllOperations()
        self.fetchImageOperations.removeAll()
        
        self.isLoading = true
        request = apiClient.searchRequest(for: searchString, in: category, with: { [weak self] (searchResult) in
            
            self?.cellViewModels = searchResult.listings.map({ ListingCellViewModel(listing: $0) })
            
            self?.isLoading = false
        }) { [weak self] (error) in
            print(error.debugDescription)
            self?.errorClosure?("Oops", error.debugDescription)
            self?.isLoading = false
        }
    }
}
