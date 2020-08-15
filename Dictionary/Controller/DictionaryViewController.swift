//
//  ViewController.swift
//  Dictionary
//
//  Created by Madi Kabdrash on 7/30/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//
import SnapKit
import UIKit
import Disk

class DictionaryViewController: UIViewController {
    
    private var viewModel = SearchDictionaryViewModel()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(DictionaryCell.self, forCellReuseIdentifier: "DictionaryCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = true
        return searchController
    }()
    private var contentType: ContentType = .history
    private var searchedText: [SearchText]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        viewModel.updateData = {
            self.tableView.reloadData()
        }
        searchedText = try? Disk.retrieve("searchText.json", from: .caches, as: [SearchText].self)
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
        switch contentType {
        case .dictionary: return viewModel.dictionary.count
        case .history: return searchedText?.count ?? 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contentType {
        case .dictionary:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell", for: indexPath) as! DictionaryCell
            cell.configure(with: viewModel.dictionary[indexPath.row])
            return cell
        case .history:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = searchedText?[indexPath.row].word ?? ""
            return cell
        }
        
    }
}
extension DictionaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentType {
        case .dictionary:
            tableView.deselectRow(at: indexPath, animated: true)
        case .history:
            contentType = .dictionary
            viewModel.fetchResult(by: searchedText?[indexPath.row].word ?? "")
        }
    }
}
extension DictionaryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           if let searchText = searchController.searchBar.text {
                contentType = .dictionary
                viewModel.fetchResult(by: searchText)
                let search = SearchText(word: searchText)
                try? Disk.append(search, to: "searchText.json", in: .caches)
           }
       }
}

