//
//  ResultViewController.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import UIKit
import SnapKit
import Alamofire

class ResultViewController: UIViewController {
    var shoppingResult : [shopData] = []
    var start = 1
    var searchResult: String
        init(searchResult: String) {
            self.searchResult = searchResult
            super.init(nibName: nil, bundle: nil)
        }
    required init?(coder: NSCoder) {
        fatalError("스또리보드를 위해 존재하는 코드")
    }
    let totalCount = {
       let totalCount = UILabel()
        totalCount.textColor = .green
        totalCount.font = .systemFont(ofSize: 14)
        return totalCount
    }()
    let shoppingCollection: UICollectionView = {
        let shoppingCollection = UICollectionViewFlowLayout()
        shoppingCollection.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - (10 * 2), height: 250)
        shoppingCollection.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        shoppingCollection.minimumLineSpacing = 10
        shoppingCollection.minimumInteritemSpacing = 10
        shoppingCollection.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: shoppingCollection)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    let naviView: UIView = {
        let naviView = UIView()
        naviView.backgroundColor = .black
        return naviView
    }()

    let backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        return backButton
    }()

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 16)
        return titleLabel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(naviView)
        view.addSubview(totalCount)
        view.addSubview(shoppingCollection)
        naviView.addSubview(backButton)
        naviView.addSubview(titleLabel)
        titleLabel.text = searchResult
        objectsLayout()
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        shoppingCollection.dataSource = self
        shoppingCollection.delegate = self
        shoppingCollection.register(ResultCollectionViewCell.self,forCellWithReuseIdentifier:ResultCollectionViewCell.identifier)
        callRequest(query: searchResult)
    }
    func callRequest(query:String) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30"
            let headers: HTTPHeaders = [
                "X-Naver-Client-Id": "nTH6ASivTQMebncWWa1t",
                "X-Naver-Client-Secret": "qzCjMA0k9W"
            ]
        AF.request(url,method: .get, headers: headers).validate(statusCode: 200..<300)
            .responseDecodable(of:SearchData.self) { response in
                switch response.result {
                case .success(let value):
                    print("서어어어엉고오오옹",value)
                    self.shoppingResult = value.items
                    self.shoppingResult.append(contentsOf: value.items)
                    self.totalCount.text = "총 검색 결과 \(value.total)개"
                    DispatchQueue.main.async { //백그라운드 스레드라 메인스레드로 넘길때 필요?한 코드, 얘도 비동기라는듯
                        self.shoppingCollection.reloadData()
                    }
                case .failure(let error):
                    print("아 제발 좀",error)
                }
        }
    }
    func objectsLayout() {
        naviView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(44)
            }

            backButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
                make.width.equalTo(40)
            }

            titleLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            totalCount.snp.makeConstraints { make in
                make.top.equalTo(naviView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(10)
                make.height.equalTo(20)
            }

            shoppingCollection.snp.makeConstraints { make in
                make.top.equalTo(totalCount.snp.bottom).offset(8)
                make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            }
    }
    @objc
    func backButtonClicked() {
        dismiss(animated: true)
    }
}
extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingResult.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (shoppingResult.count - 3) {
            start += 1
            collectionView.reloadData()
            callRequest(query: searchResult)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier , for: indexPath) as! ResultCollectionViewCell
        let row = shoppingResult[indexPath.row]
        cell.setupCell(shopData: row)
        return cell
    }
    
    
}
