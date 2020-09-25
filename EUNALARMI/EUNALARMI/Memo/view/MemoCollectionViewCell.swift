//
//  MemoCollectionViewCell.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/24.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class MemoCollectionViewCell: UICollectionViewCell {
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    var memo: Memo? {
        didSet {
            guard let memoData = memo else { return }
            self.contentLabel.text = memoData.content
            self.createLabel.text = formatter.string(from: memoData.createDate)
            self.setBorderRound(cornerRadius: 16)
            self.setShadow(cornerRadius: 16, shadowRadius: 8, shadowOpacity: 0.1, shadowOffsetWidth: 2, shadowOffsetHeight: 0)
        }
    }
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createLabel: UILabel!
    
}
