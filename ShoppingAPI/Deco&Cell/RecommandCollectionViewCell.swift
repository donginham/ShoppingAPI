//
//  RecommandCollectionViewCell.swift
//  ShoppingAPI
//
//  Created by HDI on 7/30/25.
//

import UIKit
import SnapKit
import Kingfisher

class RecommandCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommandCollectionViewCell"
    
    let recommandImage: UIImageView = {
        let recommandImage = UIImageView()
        return recommandImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupCell (shopData:shopData) {
        addObject()
        configureObject()
        setupLayout(shopData: shopData)
    }
}
extension RecommandCollectionViewCell:Configure {
    func addObject() {
        contentView.addSubview(recommandImage)
    }
    
    func configureObject() {
        contentView.addSubview(recommandImage)
        recommandImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setupLayout(shopData: shopData) {
        recommandImage.kf.setImage(with: URL(string: shopData.image))
        recommandImage.contentMode = .scaleAspectFill
        recommandImage.clipsToBounds = true
        recommandImage.layer.cornerRadius = 10
    }
}
