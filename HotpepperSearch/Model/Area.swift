//
//  Area.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//

//MARK: 大エリア
class LargeAreaItems: Decodable{
    let results: LargeAreaResults
}

class LargeAreaResults: Decodable{
    let large_area: [Area]
}

//MARK: 中エリア
class MiddleAreaItems: Decodable{
    let results: MiddleAreaResults
}

class MiddleAreaResults: Decodable {
    let middle_area: [Area]
}

//MARK: 小エリア
class SmallAreaItems: Decodable {
    let results: SmallAreaResults
}

class SmallAreaResults: Decodable {
    let small_area: [Area]
}

//MARK:共通
class Area: Decodable {
    let code: String
    let name: String
    init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}
