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
    let sorted = "sim"
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
        searchBar.searchTextField.backgroundColor = .lightGray
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.layer.borderWidth = 0
        searchBar.searchTextField.layer.borderColor = UIColor.clear.cgColor
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = UIColor.clear.cgColor
        return searchBar
    }()
    let shoppingImage = UIImageView()
    let viewModel = SearchInputViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView()
        addObject()
        configureObject()
        connectData()
        
    }
    func showAlert(title: String, message: String, okTitle: String = "확인") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okTitle, style: .default)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
}
extension ViewController: Configure,UISearchBarDelegate{
    func settingView(){
        view.backgroundColor = .black
        let imgUrl = "https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/587.png"
        shoppingImage.kf.setImage(with: URL(string: imgUrl))
        
    }
    func configureObject() {
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
    func addObject() {
        view.addSubview(titleBar)
        view.addSubview(searchBar)
        view.addSubview(shoppingImage)
    }
    func connectData() {
        searchBar.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("엔터누름진짜임")
        guard let text = searchBar.text, !text.isEmpty else {
            print("빈값 입력")
            return
        }
        searchBar.resignFirstResponder()
        viewModel.inputSearchQuery.value = text
        
        let VC = ResultViewController(searchResult: text, sorted: viewModel.sorted)
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true)
        
        searchBar.text = ""
    }
}
