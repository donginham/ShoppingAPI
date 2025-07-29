//
//  ResultViewController.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import UIKit
import SnapKit

class ResultViewController: UIViewController {
   
    var shoppingResult : [shopData] = []
    var display = 30
    var count = 1
    let indexPath = IndexPath(row: NSNotFound, section: 0)
    
    var searchResult: String
        init(searchResult: String) {
            self.searchResult = searchResult
            super.init(nibName: nil, bundle: nil)
        }
    required init?(coder: NSCoder) {
        fatalError("스또리보드를 위해 존재하는 코드")
    }
    
    //MARK: Object 선언
    let totalLabel = {
       let totalLabel = UILabel()
        totalLabel.textColor = .green
        totalLabel.font = .systemFont(ofSize: 14)
        return totalLabel
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
    
    func convertInt (count requestIntValue: Int) -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numPrice: String = numberFormatter.string(for: requestIntValue)!
        return numPrice
    }
    //MARK: viewDidLoad  호출 -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        titleLabel.text = searchResult
        
        addObject()
        configureObject()
        connectData()
        callRequest(query: searchResult,display: display)
        
    }
    func callRequest(query: String,display: Int) {
        NetworkManager.shared.callRequest(query: query,display: display) { value in
            print("성공성공",value)
            if display == 1 {
                self.shoppingResult = value.items
            } else {
                self.shoppingResult.append(contentsOf: value.items)
            }
            self.count = value.total
            self.display = value.display
            self.totalLabel.text = "총 검색 결과 \(self.convertInt(count :value.total))개"
                self.shoppingCollection.reloadData()
            if self.display == 1 {
                self.shoppingCollection.scrollToItem(at: self.indexPath as IndexPath, at: .top, animated: false)
            }
        } failed: {
            print("앗 실패")
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
        if indexPath.row == (shoppingResult.count - 2) && count > display {
            if count > display {
                display += 30
            } else {
                display = display + (count - display)
            }
            shoppingCollection.reloadData()
            callRequest(query: searchResult,display: display)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier , for: indexPath) as! ResultCollectionViewCell
        let row = shoppingResult[indexPath.row]
        cell.setupCell(shopData: row)
        return cell
    }
}

extension ResultViewController: Configure {
    func configureObject() {
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
        totalLabel.snp.makeConstraints { make in
                make.top.equalTo(naviView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(10)
                make.height.equalTo(20)
            }
            shoppingCollection.snp.makeConstraints { make in
                make.top.equalTo(totalLabel.snp.bottom).offset(8)
                make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            }
    }
    func addObject() {
        view.addSubview(naviView)
        view.addSubview(totalLabel)
        view.addSubview(shoppingCollection)
        naviView.addSubview(backButton)
        naviView.addSubview(titleLabel)
    }
    func connectData() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        shoppingCollection.dataSource = self
        shoppingCollection.delegate = self
        shoppingCollection.register(ResultCollectionViewCell.self,forCellWithReuseIdentifier:ResultCollectionViewCell.identifier)
        
    }
}
