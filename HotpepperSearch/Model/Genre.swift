//
//  Janle.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/17.
//

import Foundation

class Items: Decodable {
    let results: Results

}

class Results: Decodable {
    let genre: [Genre]
}

class Genre: Decodable {
    let code: String
    let name: String
}
