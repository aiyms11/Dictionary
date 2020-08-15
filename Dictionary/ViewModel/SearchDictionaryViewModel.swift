//
//  SearchDictionaryViewModel.swift
//  Dictionary
//
//  Created by Madi Kabdrash on 7/30/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation
import Alamofire

class SearchDictionaryViewModel {
    var service = DictionaryServiceImpl()
    var dictionary:[Dictionary] = []
    var updateData: (() -> Void)?
    
    func fetchResult(by text: String) {
        service.getDictionaryWords(by: text) { [weak self] dictionary in
            print(dictionary)
                self?.dictionary = dictionary
                self?.updateData?()
        }
    }
}
