//
//  NetworkManager.swift
//  ShoppingAPI
//
//  Created by HDI on 7/29/25.
//
import UIKit
import Alamofire
class NetworkManager {
    private init() { }
    static let shared = NetworkManager()
    func callRequest(query:String, display: Int, sort: String,
                     success:@escaping (SearchData) -> Void,
                     failed:@escaping (String) -> Void) { //에러메세지 전달하는중
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(display)&sort=\(sort)"
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
                    if let statusCode = response.response?.statusCode {
                        let errorMessage = self.networkError(statusCode)
                        failed(errorMessage)
                    } else {
                        failed("인터넷연결을 확인해주세요!")
                    }
                }
            }
    }
    func networkError(_ statusCode: Int) -> String {
            switch statusCode {
            case 400..<500:
                return "네트워크 오류입니다."
            default:
                return "네트워크 요청에 실패했습니다."
            }
        }
}
