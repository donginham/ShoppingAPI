//
//  ResultItemCollectionViewCell.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import UIKit
import Kingfisher
class ResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResultCollectionViewCell"
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
    func setupCell (item: items) {
        setupLayout(result: item)
    }
}
private extension ResultCollectionViewCell {
    func setupLayout(result: items) {
        itemTitle.text = result.title
        mallLabel.text = result.mallName
        itemImage.kf.setImage(with: URL(string: result.image))
    }
}
