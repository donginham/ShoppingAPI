//
//  SearchViewModel.swift
//  ShoppingAPI
//
//  Created by HDI on 8/12/25.
//

import Foundation
import Alamofire

final class SearchInputViewModel {
    var inputSearchQuery: Observable<String> = Observable("")
    var outputSearchResults: Observable<[shopData]> = Observable([])
    //값
    var outputErrorMessage: Observable<String?> = Observable(nil)
    //에러 얼러트용
    var sorted: String = "sim" //
    init() {
        inputSearchQuery.bind { value in
            let query = value
            if query.isEmpty {
                return
            }
            self.callRequest(query: query, display: 100, sort: self.sorted)
        }
    }
    func callRequest(query: String, display: Int, sort: String) {
            NetworkManager.shared.callRequest(query: query, display: display, sort: sort) { data in
                self.outputSearchResults.value = data.items
                self.outputErrorMessage.value = nil
            } failed: { error in
                self.outputErrorMessage.value = error
                self.outputSearchResults.value = []
            }
        }
        func value(for data: shopData, type: shopData.Data) -> String {
            switch type {
            case .title:
                return data.title
            case .image:
                return data.image
            case .lprice:
                return data.lprice
            case .mallName:
                return data.mallName
            }
        }
    }

