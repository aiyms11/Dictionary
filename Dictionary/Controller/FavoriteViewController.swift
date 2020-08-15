//
//  History.swift
//  Dictionary
//
//  Created by Madi Kabdrash on 8/15/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation
import CoreData
import SnapKit
import UIKit

class FavoriteViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(DictionaryCell.self, forCellReuseIdentifier: "DictionaryCell")
        return tableView
    }()
    private var favorite:[Favorite] = []{
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorite = fetch()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    private func fetch() -> [Favorite] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favorite = try? context.fetch(fetchRequest) else { return [] }
        return favorite
    }
}

extension FavoriteViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell", for: indexPath) as! DictionaryCell
        cell.configure(with: favorite[indexPath.row])
        return cell
    }
}
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: "Remove") { (action, view, success) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
            guard let favs = try? context.fetch(fetchRequest) else { return }
            let fav = favs[indexPath.row]
            context.delete(fav)
            try? context.save()
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
