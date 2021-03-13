//
//  AnalyticsModel.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/12.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DoneCatchDataProtcol {
    //規則を決める
    func catchData(arrayData:Array<ShopData>,resultCount:Int)
}

class AnalyticsModel{
    
    //外部から渡ってくる緯度
    var latitudeValue:Double?
    var longitudeValue:Double?
    var urlString:String?
    var shopDataArray = [ShopData]()
    var doneCatchDataProtcol :DoneCatchDataProtcol?
    
    //ViewControllerから値を受け取る
    init(latitude:Double,longitude:Double,url:String){
        latitudeValue = latitude
        longitudeValue = longitude
        urlString = url
    }
    //JSON解析を行う
    func setData(){
        //urlエンコーディング
        guard let url = urlString else {
            return
        }
        guard  let encordeUrlString :String = (url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ) else{ return}
        AF.request(encordeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            print("response",response.debugDescription)
            switch response.result{
            case .success :
            do{
                guard let responseData =  response.data else{return}
                let json:JSON = try JSON(data:responseData)
                guard var totalHitCount = json["results"]["results_available"].int else {return }
                
                if totalHitCount > 50{
                    totalHitCount = 50
                }
                if totalHitCount != 0{
                    for i in 0...totalHitCount - 1{
                        if json["results"]["shop"][i]["lat"] != "" && json["results"]["shop"][i]["lng"] != "" && json["results"]["shop"][i]["coupon_urls"]["pc"] != "" && json["results"]["shop"][i]["name"] != ""{
                            
                            let shopData = ShopData(latitude: json["results"]["shop"][i]["lat"].double, longitude: json["results"]["shop"][i]["lng"].double,
                                                    url: json["results"]["shop"][i]["coupon_urls"]["pc"].string, name: json["results"]["shop"][i]["name"].string)
                            
                            self.shopDataArray.append(shopData)
                            print(self.shopDataArray.debugDescription)
                        }else{
                            print("値が空です")
                        }   
                    }
                }
                //値をViewControllerへ返却
                self.doneCatchDataProtcol?.catchData(arrayData: self.shopDataArray, resultCount: self.shopDataArray.count)
            }catch{
                    print("エラーです",error)
            }
            break
            case .failure:break
            }
            
            
        }
        
    }
    
    
    
    
    
}
