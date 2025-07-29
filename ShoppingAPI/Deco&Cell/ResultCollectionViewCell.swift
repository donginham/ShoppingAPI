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
        addObject()
        configureObject()
    }
}
extension ResultCollectionViewCell: Configure {
    
    
    func addObject() {
        let objects = [itemImage,mallLabel,itemTitle,itemPrice]
        
        objects.forEach { view in
            contentView.addSubview(view)
        }
    }
    
    func setupLayout(result: shopData) {
        let requestIntValue =  Int(result.lprice)
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numPrice: String = numberFormatter.string(for: requestIntValue)!

        itemTitle.text = result.title.htmlEscaped
        mallLabel.text = result.mallName
        itemPrice.text  = "\(numPrice)원"
        itemImage.kf.setImage(with: URL(string: result.image))
    }
    func configureObject() {
        itemImage.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp.bottom).offset(5)
            make.height.equalTo(14)
            make.horizontalEdges.equalTo(itemImage.snp.horizontalEdges)
        }
        itemTitle.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(5)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(mallLabel.snp.horizontalEdges)
        }
        itemPrice.snp.makeConstraints { make in
            make.top.equalTo(itemTitle.snp.bottom).offset(5)
            make.height.equalTo(25)
            make.horizontalEdges.equalTo(itemTitle.snp.horizontalEdges)
        }
        itemImage.layer.cornerRadius = 10
        itemImage.clipsToBounds = true
        mallLabel.font = .systemFont(ofSize: 12)
        mallLabel.textColor = .lightGray
        itemTitle.font = .systemFont(ofSize: 12)
        itemTitle.textColor = .white
        itemTitle.numberOfLines = 2
        itemPrice.font = .systemFont(ofSize: 16,weight: .bold)
        itemPrice.textColor = .white
    }
}
extension String {
    var htmlEscaped: String {
        let regex = try! NSRegularExpression(pattern: "<[^>]+>", options: [])
        let range = NSRange(location: 0, length: self.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
}
