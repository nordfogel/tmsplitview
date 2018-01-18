//
//  CategoryViewController.swift
//  trademe
//
//  Created by Bjoern Bengelsdorf on 13.01.18.
//  Copyright © 2018 bengelsdorf. All rights reserved.
//

import UIKit

protocol CategorySelectionDelegate: class {
    func didSelectCategory(with id: String)
    func didEnter(_ searchString: String, for category: String)
}

final class CategoriesViewController: UITableViewController {

    var viewModel: CategoriesViewModelProtocol?
    @IBOutlet var activityView: UIActivityIndicatorView!
    @IBOutlet var allButton: UIButton!
    @IBOutlet var listingsBarButton: UIBarButtonItem!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBAction func didTapButton(sender: Any?) {
        
        if let indexPath = viewModel?.selectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        viewModel?.selectedIndexPath = nil
        allButton.backgroundColor = UIColor.groupTableViewBackground
        if let categoryId = self.viewModel?.identifierForSelectedCategory, let searchString = self.viewModel?.searchString {
            self.delegate?.didEnter(searchString, for: categoryId)
        }
    }
    
    weak var delegate: CategorySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel?.title
        
        viewModel?.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                
                if let totalCount = self?.viewModel?.totalCount {
                    self?.countLabel.text = totalCount
                }
                if let categoryId = self?.viewModel?.identifierForSelectedCategory, let searchString = self?.viewModel?.searchString {
                    self?.delegate?.didEnter(searchString, for: categoryId)
                }
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
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            self.viewModel?.fetchSubcategories()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let categoryId = self.viewModel?.identifierForSelectedCategory, let searchString = self.viewModel?.searchString {
            self.delegate?.didEnter(searchString, for: categoryId)
        }
        
        searchBar.text = viewModel?.searchString
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.itemCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard var viewModel = viewModel else {
            return nil
        }
        viewModel.selectedIndexPath = indexPath
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) //as? ListingCell
        if let cellViewModel = viewModel?.cellViewModel(at: indexPath.row) {
            cell.textLabel?.text = cellViewModel.title
            cell.detailTextLabel?.text = cellViewModel.subtitle
            cell.accessoryType = cellViewModel.showAccessoryIndicator ? .disclosureIndicator : .none
        }
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        allButton.backgroundColor = .white
        guard let viewModel = viewModel else {
            return
        }
        
        if let categoryId = viewModel.identifierForSubcategory(at: indexPath.row) {
            delegate?.didEnter(viewModel.searchString, for: categoryId)
        }
        
        if viewModel.isSelectionAllowed(at: indexPath.row) {
             performSegue(withIdentifier: "NextCategory", sender: nil)
        } else if let splitView = self.splitViewController, splitView.isCollapsed {
            performSegue(withIdentifier: "ShowListings", sender: nil)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CategoriesViewController {
            destination.viewModel = viewModel?.viewModelForSelectedSubcategory()
            destination.delegate = self.delegate
        }
    }
}

extension CategoriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, let categoryId = viewModel?.identifierForSelectedCategory, var viewModel = viewModel, viewModel.searchString != text && text != "" {
            viewModel.searchString = text
            self.delegate?.didEnter(text, for: categoryId)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel?.searchString = searchText
            if let categoryId = viewModel?.identifierForSelectedCategory {
                self.delegate?.didEnter("", for: categoryId)
            }
        }
    }
}
