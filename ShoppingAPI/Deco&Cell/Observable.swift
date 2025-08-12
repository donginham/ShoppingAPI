//
//  Observable.swift
//  ShoppingAPI
//
//  Created by HDI on 8/12/25.
//

import Foundation
class Observable<T> {
    private var action :((T)->Void)?
    var value : T {
        didSet {
            print("값 반응",value)
            action?(value) // 값이 바뀔 때 액션 함수 실행
        }
    }
    
    
    init(_ value: T) {
        self.value = value
    }
    func bind(action: @escaping (T) -> Void) {
        print("바인드실행")
        self.action = action
    } //뷰 모델안에 액션을 꺼내와 주는 함수 - 값이 바뀔 때 실행, 하지만? 뷰 이동 등 값이 바뀌지않는다면 액션이 실행되지않음, 그렇다고 액션부터 실행해 버리면 2중으로 실행될 수도 있음.
    func lazybind(action: @escaping (T) -> Void) {
        action(value)
        print("바인드실행")
        self.action = action
    }
}
