//
//  NewMemoViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/24.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class NewMemoViewController: UIViewController {
    var mode: Mode = .new
    var editMemo: Memo? {
        didSet {
            mode = .edit
        }
    }
    var memoIndex: Int?
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        }
        
        switch mode {
        case .new:
            let userInfo = ["memo": Memo(content: memo)]
            NotificationCenter.default.post(name: Notification.Name.Memo.Insert, object: nil, userInfo: userInfo)
        case .edit:
            guard let target = editMemo, let index = memoIndex else { return }
            target.content = memo
            let userInfo = ["memo": target, "index": index] as [String : Any]
            NotificationCenter.default.post(name: Notification.Name.Memo.Edit, object: nil, userInfo: userInfo)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func configureUI() {
        switch mode {
        case .new:
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        case .edit:
            navigationItem.title = "메모 편집"
            memoTextView.text = editMemo?.content
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
}
