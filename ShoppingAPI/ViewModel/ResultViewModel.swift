//
//  ResultViewModel.swift
//  ShoppingAPI
//
//  Created by HDI on 8/13/25.
//

import Foundation

final class ResultViewModel {

    var searchQuery: Observable<String> = Observable("")
    var changeSort: Observable<String> = Observable("sim")  // 이이일단 기본은 정확도

    var searchResults: Observable<[shopData]> = Observable([])
    var totalCount: Observable<Int> = Observable(0)
    var errorMessage: Observable<String?> = Observable(nil)

    init() {
        searchQuery.bind { _ in
            print("서치쿼리 - init")
            self.updateRequest()
        }
        changeSort.bind { _ in
            print("우선도  - init")
            self.updateRequest()
        }
    }

    private func updateRequest() {
        let query = searchQuery.value
        let sort = changeSort.value
        if query.isEmpty {
            return
        }
        callRequest(query: query, sort: sort)
    }

    func callRequest(query: String, sort: String) {
        NetworkManager.shared.callRequest(query: query, display: 100, sort: sort) { data in
            self.searchResults.value = data.items
            self.totalCount.value = data.total
            self.errorMessage.value = nil
        } failed: { errorMsg in
            self.errorMessage.value = errorMsg
            self.searchResults.value = []
            self.totalCount.value = 0
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

    func changeSort(_ updateSort: String) {
        print("정렬바꾸기")
        changeSort.value = updateSort
    }
}

