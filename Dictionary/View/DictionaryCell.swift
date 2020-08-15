//
//  DictionaryCell.swift
//  Dictionary
//
//  Created by Madi Kabdrash on 8/15/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation
import CoreData
import SnapKit
import UIKit

final class DictionaryCell: UITableViewCell {
    
    private lazy var word: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private lazy var definition: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.numberOfLines = 10
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" + add", for: .normal)
        button.addTarget(self, action: #selector(didAddPressed), for: .touchUpInside)
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [word, definition, addButton])
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(with dictionary: Dictionary) {
        word.text = dictionary.word
        definition.text = dictionary.definition
    }
    
    func configure(with favorite: Favorite) {
        word.text = favorite.word
        definition.text = favorite.defenition
        addButton.isHidden = true
    }
    
    private func setupUI() {
        addSubview(stackView)
        setupContraints()
    }
    
    private func setupContraints() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc func didAddPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fav = Favorite(context: context)//Favorite(context: context)
        fav.word = word.text
        fav.defenition = definition.text
        try? context.save()
    }
}
