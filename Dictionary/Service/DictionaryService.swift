//
//  DictionaryService.swift
//  Dictionary
//
//  Created by Madi Kabdrash on 7/30/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation
import Alamofire

protocol DictionaryService {
    func getDictionaryWords(by text: String, completion: @escaping ([Dictionary]) -> Void)
}
class DictionaryServiceImpl {
    func getDictionaryWords(by text: String, completion: @escaping ([Dictionary]) -> Void) {
        let completionHandler: (DataResponse<DictionaryWrapper, AFError>) -> Void = { response in
            switch response.result {
            case let .success(result):
                completion(result.list)
            case .failure:
                completion([])
            }
        }
        AF.request("http://api.urbandictionary.com/v0/define?term=\(text)",
                   method: .get)
            .responseDecodable(completionHandler: completionHandler)
    }
}


