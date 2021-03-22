//
//  Shop.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//

import Foundation
class ShopItems:Decodable{
    let results :ShopResult
}
class ShopResult:Decodable{
    let shop:[Shop]
}
class Shop:Decodable{
    let name :String
    let genre:ShopGenre
    let `catch` :String
    let address :String
    let budget:Budget
    let photo :Photo
    let urls :URLS
    let free_drink :String
}
//料金
class Budget:Decodable{
    let code :String
    let name :String
    let average :String
}
//ジャンル
class ShopGenre:Decodable{
    let `catch` :String
    let code :String
    let name :String
}
class URLS:Decodable{
    let pc:String
}

class Photo:Decodable{
    let mobile:L
}
class L :Decodable{
    let l:String
}
