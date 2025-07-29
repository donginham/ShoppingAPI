//
//  SearchData.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import Foundation
import Alamofire
struct SearchData: Decodable {
    let total: Int
    let start: Int
    let items : [shopData]
}
struct shopData: Decodable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
}
