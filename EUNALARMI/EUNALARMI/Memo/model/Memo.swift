//
//  Memo.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/23.
//  Copyright © 2020 60080252. All rights reserved.
//

import Foundation

class Memo: Codable {
    var content: String
    var createDate: Date
    
    init(content: String) {
        self.content = content
        createDate = Date()
    }
    
    static var dummyMemoList = [
    Memo(content: "Lorem Ipsum"),
    Memo(content: "Subscribe + 👍 = ❤️"),
    Memo(content: "나는 은영이양 하이루"),
    Memo(content: "호호호호ㅗ호 퇵은 퇵은 하고 싶어요")
    ]
}

enum Mode {
    case new
    case edit
}
