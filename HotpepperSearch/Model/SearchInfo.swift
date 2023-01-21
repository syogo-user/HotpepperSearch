//
//  SearchInfo.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/18.
//

import Foundation

class SearchInfo :NSObject {
    let id: String
    let name: String
    var check: Bool = false
    
    init(id :String ,name: String, check: Bool) {
        self.id = id
        self.name  = name
        self.check = check
    }
    
    func setCheckState (check: Bool) {
        self.check = check
    }
}
