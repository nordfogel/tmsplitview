//
//  ListingsViewController.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 14.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import UIKit

struct ListingCellViewModel: ListItemCellViewModelProtocol {
    let id: String
    var showAccessoryIndicator: Bool
    let title: String
    let subtitle: String
    private (set) var thumbUrl: URL?

    init(listing: Listing) {
        id = String(listing.id)
        title = listing.title
        subtitle = listing.category
        thumbUrl = listing.primaryThumbUrl
        showAccessoryIndicator = false
    }
}

extension ListingsViewController: CategorySelectionDelegate {
    
    func didSelectCategory(with id: String) {
        viewModel?.fetchListings(for: "", in: id)
    }
    
    func didEnter(_ searchString: String, for category: String) {
        viewModel?.fetchListings(for: searchString, in: category)
    }
}


final class ListingsViewController: UITableViewController {

    @IBOutlet var activityView: UIActivityIndicatorView!
    
    var viewModel: ListingsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.prefetchDataSource = self
        
        title = viewModel?.title
        
        viewModel?.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.updateLoadingState = { [weak self] (isLoading: Bool) in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityView.startAnimating()
                } else {
                    self?.activityView.stopAnimating()
                }
            }
        }
    }
}

extension ListingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.itemCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath)
        if let cellViewModel = viewModel?.cellViewModel(at: indexPath.row) {
            
            cell.textLabel?.text = cellViewModel.title
            cell.detailTextLabel?.text = cellViewModel.subtitle
            cell.imageView?.image = UIImage(named: "placeholder")
            
            viewModel?.imageCompletion(at: indexPath, completion: { (image) in
                
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                }
            })
        }

        return cell
    }
}

extension ListingsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
                // TODO
//        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
            // TODO
//        }
    }
}
