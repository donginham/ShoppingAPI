//
//  Deco.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import Foundation
@objc
protocol Configure {
    
    @objc
    optional func settingView()
    
    func addObject()
    func configureObject()
    
    @objc
    optional func  connectData()
}
