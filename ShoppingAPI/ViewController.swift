//
//  ViewController.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import UIKit
import Alamofire
import SnapKit
class ViewController: UIViewController {
    
    let titleBar = {
        let titleBar = UILabel()
        titleBar.text = "쇼오오오핑"
        titleBar.textAlignment = .center
        return titleBar
    }()
    let searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.backgroundColor = .lightGray
        
        return searchBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleBar)
        view.addSubview(searchBar)
        
        configureDeco()
        callRequest()
    }
    func callRequest() {
        let url = "https://openapi.naver.com/v1/search/shop.xml?query=\(searchBar.text ?? "캠핑카")&display=30"
        print(url)
        let headers: HTTPHeaders = [
                    "X-Naver-Client-Id": "nTH6ASivTQMebncWWa1t",
                    "X-Naver-Client-Secret": "X9yuamZgud"
                ]
        AF.request(url,method: .get,headers: headers).responseDecodable(of:SearchData.self) { reponse in
            switch reponse.result {
            case .success(let value):
                print("성공",value)
            
            case .failure(let error): 
                print("실패!",error)
            }
        }
    }
}
extension ViewController: Deco,UISearchBarDelegate{
    func configureDeco() {
        titleBar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view)
            make.top.equalTo(view.layoutMarginsGuide)
        }
        searchBar.snp.makeConstraints {make in
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(44)
            make.top.equalTo(titleBar.snp.top).offset(50)
        }
        searchBar.delegate = self
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let VC = ResultViewController(searchResult: searchBar.text ?? "")
        navigationController?.pushViewController(VC, animated: true)
    }
}
