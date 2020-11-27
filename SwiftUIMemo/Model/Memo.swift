//
//  Memo.swift
//  SwiftUIMemo
//
//  Created by pparkst on 2020/11/27.
//  Copyright © 2020 pparkst. All rights reserved.
//

import SwiftUI
//Identifiable : 데이터 바인딩이 편함
//ObservableObject : 반응형 앱을 구현하기위함
class Memo: Identifiable, ObservableObject {
    let id: UUID
    @Published var content: String
    //바인딩 되어있는 UI가 자동으로 UPDATE됨
    let insertDate: Date
    
    init(id: UUID = UUID(), content: String, insertDate: Date = Date()) {
        self.id = id
        self.content = content
        self.insertDate = insertDate
    }
}

extension Memo: Equatable {
    static func == (lhs: Memo, rhs: Memo) -> Bool {
        return lhs.id == rhs.id
    }
}
