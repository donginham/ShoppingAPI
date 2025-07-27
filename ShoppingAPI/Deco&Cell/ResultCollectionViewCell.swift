//
//  ResultItemCollectionViewCell.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import UIKit
import Kingfisher
import SnapKit
class ResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResultCollectionViewCell"
    let objects:[String] = ["itemImage","mallLabel","itemTitle","itemPrice"]
    let itemImage = {
        let itemImage = UIImageView()
        return itemImage
    }()
    let mallLabel = {
        let mallLabel = UILabel()
        return mallLabel
    }()
    let itemTitle = {
        let itemTitle = UILabel()
        return itemTitle
    }()
    let itemPrice = {
        let itemPrice = UILabel()
        return itemPrice
    }()
    func setupCell (shopData:shopData) {
        setupLayout(result: shopData)
        itemImage.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.verticalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(160)
            
        }
    }
}
private extension ResultCollectionViewCell {
    func setupLayout(result: shopData) {
        contentView.addSubview(itemImage)
        contentView.addSubview(itemPrice)
        contentView.addSubview(<#T##view: UIView##UIView#>)
        itemTitle.text = result.title
        mallLabel.text = result.mallName
        itemPrice.text  = result.lprice
        
        itemImage.kf.setImage(with: URL(string: result.image))
    }
}
