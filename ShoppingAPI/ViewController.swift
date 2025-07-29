//
//  ViewController.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher
class ViewController: UIViewController {
    
    let titleBar = {
        let titleBar = UILabel()
        titleBar.text = "쇼핑API"
        titleBar.textColor = .white
        titleBar.font = .systemFont(ofSize: 20,weight: .bold)
        titleBar.textAlignment = .center
        return titleBar
    }()
    let searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.backgroundColor = .black
        
        return searchBar
    }()
    let shoppingImage = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(titleBar)
        view.addSubview(searchBar)
        view.addSubview(shoppingImage)
        let imgUrl = "https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/587.png"
        shoppingImage.kf.setImage(with: URL(string: imgUrl))
        configureDeco()
        callRequest(query: "캠핑카")
        searchBar.delegate = self
    }
    func callRequest(query: String) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30"
        print(url)
        let headers: HTTPHeaders = [
                    "X-Naver-Client-Id": "nTH6ASivTQMebncWWa1t",
                    "X-Naver-Client-Secret": "qzCjMA0k9W"
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
        shoppingImage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.size.equalTo(300)
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("엔터누름진짜임")
        guard let text = searchBar.text, text.count > 0 else {
            print("빈값 입력")
            return
        }
        searchBar.text = ""
        let VC = ResultViewController(searchResult: text)
        VC.modalPresentationStyle = .fullScreen
        present(VC,animated: true)
        callRequest(query: text)
        
    }
}
