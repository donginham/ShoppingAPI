//
//  NetworkManager.swift
//  ShoppingAPI
//
//  Created by HDI on 7/29/25.
//
import UIKit
import Alamofire
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    func callRequest(query:String,display: Int,
                     success:@escaping (SearchData) -> Void,
                     failed:@escaping () -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(display)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "nTH6ASivTQMebncWWa1t",
            "X-Naver-Client-Secret": "qzCjMA0k9W"
        ]
        AF.request(url,method: .get, headers: headers).validate(statusCode: 200..<300)
            .responseDecodable(of:SearchData.self) { response in
                switch response.result {
                case .success(let value):
                    success(value)
                    print("서어어어엉고오오옹")
                case .failure(let error):
                    print("아 제발 좀",error)
                    failed()
                }
            }
    }
}
