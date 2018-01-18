//
//  CategoriesViewModel.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 17.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import Foundation

protocol ListItemCellViewModelProtocol {
    var id: String { get } // Int
    var title: String { get }
    var subtitle: String { get }
    var thumbUrl: URL? { get }
    var showAccessoryIndicator: Bool { get }
}

struct CategoryCellViewModel: ListItemCellViewModelProtocol {
    let id: String
    let title: String
    let subtitle: String
    var thumbUrl: URL?
    let showAccessoryIndicator: Bool
    
    init(category: Category) {
        id = category.identifier
        title = category.name
        subtitle = "\(category.numberOfItemsForSale ?? 0)"
        showAccessoryIndicator = !category.isLeaf
        thumbUrl = nil
    }
}

protocol ListViewModelProtocol {
    var title: String { get }
    var itemCount: Int { get }
    var reloadClosure: (()->Void)? { get set }
    var updateLoadingState: ((Bool)->Void)? { get set }
    func cellViewModel(at index: Int) -> ListItemCellViewModelProtocol?
}

protocol SubcategoryViewModelProtocol {
    var totalCount: String { get }
    var identifierForSelectedCategory: String? { get }
    var selectedIndexPath: IndexPath? { get set }
    func fetchSubcategories()
    func isSelectionAllowed(at index: Int) -> Bool
    func identifierForSubcategory(at index: Int) -> String?
    func viewModelForSelectedSubcategory() -> CategoriesViewModelProtocol?
}

typealias CategoriesViewModelProtocol = ListViewModelProtocol & SubcategoryViewModelProtocol


final class CategoriesViewModel: CategoriesViewModelProtocol { //NSObject,

    let apiClient: TradeMeApiProtocol //& NSObjectProtocol
    
    private var request: ApiRequest<CategoryApiResource>?
    private var model: Category
    private var cellViewModels: [ListItemCellViewModelProtocol]? {
        didSet {
            self.reloadClosure?()
        }
    }
    
    var totalCount: String {
        return String(model.numberOfItemsForSale ?? 0)
    }
    
    var itemCount: Int {
        return cellViewModels?.count ?? 0
    }
    
    var selectedIndexPath: IndexPath?
    
    var errorClosure: ((String, String)->Void)?
    var reloadClosure: (()->Void)?
    var updateLoadingState: ((Bool)->Void)?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingState?(isLoading)
        }
    }
    
    var title: String {
        return model.name
    }
    
    init(apiClient: TradeMeApiProtocol, category: Category) {
        self.apiClient = apiClient
        model = category
        
    }
    
    func cellViewModel(at index: Int) -> ListItemCellViewModelProtocol? {
        guard index >= 0 && index < itemCount else {
            return nil
        }
        return cellViewModels?[index]
    }
    
    func isSelectionAllowed(at index: Int) -> Bool {
        guard let subcategories = model.subcategories, index >= 0 && index < itemCount else {
            return false
        }
        return !subcategories[index].isLeaf
    }
    
    var identifierForSelectedCategory: String? {
        if let index = selectedIndexPath?.row {
            return identifierForSubcategory(at: index)
        } else {
            return model.identifier
        }
    }
        
    func identifierForSubcategory(at index: Int) -> String? {
        guard index >= 0 && index < itemCount, let subcategory = model.subcategories?[index] else {
            return nil
        }
        return subcategory.identifier
    }
    
    func viewModelForSelectedSubcategory() -> CategoriesViewModelProtocol? {

        guard let index = selectedIndexPath?.row, index >= 0 && index < itemCount else {
            return nil
        }
        if let subcategory = model.subcategories?[index] {
            return CategoriesViewModel(apiClient: apiClient, category: subcategory)
        }
        return nil
    }
    
    func fetchSubcategories() {
        guard let subcategories = model.subcategories, isLoading == false else {
            fetchSubcategories(for: model.identifier)
            return
        }
        
        guard let _ = cellViewModels else {
        cellViewModels = subcategories.map({ CategoryCellViewModel(category: $0) })
        isLoading = false
            return
        }
    }
    
    private func fetchSubcategories(for categoryIdentifier: String) {
        self.isLoading = true
        request = apiClient.categoryRequest(for: categoryIdentifier, searchDepth: nil, with: { [weak self] (category) in
                if let subcategories = category.subcategories {
                    self?.model = category
                    self?.cellViewModels = subcategories.map({ CategoryCellViewModel(category: $0) })
                } else {
                    self?.cellViewModels = []
                }
                self?.isLoading = false
        }) { [weak self] (error) in
                print(error.debugDescription)
                self?.errorClosure?("Oops", error.debugDescription)
                self?.isLoading = false
        }
    }
}
