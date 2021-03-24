//
//  SearchCondition.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/14.
//
import Foundation
class SerachCondition:NSObject{
    var imageName = ""
    var title = ""
    var conditionValue :String?
    
    
    init(_ imageName :String,_ title :String,_ conditionValue:String ) {
        self.imageName = imageName
        self.title = title
        self.conditionValue = conditionValue
    }
}
