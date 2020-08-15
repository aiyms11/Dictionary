//
//  ViewController.swift
//  Dictionary
//
//  Created by Madi Kabdrash on 7/30/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import UIKit
import SnapKit

class DictionaryViewController: UIViewController {
    
    private var viewModel = SearchDictionaryViewModel()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(DictionaryCell.self, forCellReuseIdentifier: "DictionaryCell")
        return tableView
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = true
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        viewModel.updateData = {
            self.tableView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Dictionary"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }

}

extension DictionaryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell", for: indexPath) as! DictionaryCell
        cell.configure(with: viewModel.dictionary[indexPath.row])
        return cell
    }
}
extension DictionaryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           if let searchText = searchController.searchBar.text {
               viewModel.fetchResult(by: searchText)
           }
       }
}

