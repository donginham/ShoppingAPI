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
    var shoppingResult : [items] = []
    var searchResult: String

        init(searchResult: String) {
            self.searchResult = searchResult
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("스또리보드를 위해 존재하는 코드")
    }
    let shoppingCollection = {
        let shoppingCollection = UICollectionView()
        return shoppingCollection
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingCollection.dataSource = self
        shoppingCollection.delegate = self
        shoppingCollection.register(ResultCollectionViewCell.self,forCellWithReuseIdentifier:ResultCollectionViewCell.identifier)
        
    }
}
extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier , for: indexPath) as! ResultCollectionViewCell
        let row = shoppingResult[indexPath.row]
        return cell
    }
    
    
}
