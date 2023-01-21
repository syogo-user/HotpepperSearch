//
//  API.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/17.
//

import Foundation
import Alamofire
import SVProgressHUD

class API {
    enum PathType: String {
        case gourmet
        case genre
        case large_area
        case middle_area
        case small_area
    }
    
    static let shared = API()
    private let baseUrl = "http://webservice.recruit.co.jp/hotpepper/"
    
    func request<T:Decodable>(path :PathType,params: [String: Any], type: T.Type, completion: @escaping (T) -> Void) {
        
        let path = path.rawValue
        let url = baseUrl  + path + "/v1/" + "?"
        var params = params
        params["key"] = "834159f2a4601857"
        params["count"] = 100
        params["format"] = "json"
        
        let request = AF.request(url, method: .get, parameters: params)
        request.responseJSON { (response) in
            guard let statucCode =  response.response?.statusCode else { return }
            if statucCode <= 300 {
                do{
                    guard let data = response.data else { return }
                    let decorder = JSONDecoder()
                    let value = try decorder.decode(T.self, from: data)
                    completion(value)
                } catch {
                    print("変換に失敗しました。：",error)
                    SVProgressHUD.dismiss()
                }
                
            }
        }
    }
}
