//
//  Dictionary.swift
//  Dictionary
//
//  Created by Madi Kabdrash on 7/30/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation

struct Dictionary: Codable {
    let definition: String
    let word: String
}
struct DictionaryWrapper: Codable {
    let list: [Dictionary]
}
