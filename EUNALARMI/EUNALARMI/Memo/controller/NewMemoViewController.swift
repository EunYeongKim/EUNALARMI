//
//  NewMemoViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/24.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class NewMemoViewController: UIViewController {
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        }
        
        let newMemo = Memo(content: memo)
        Memo.dummyMemoList.append(newMemo)
        
        NotificationCenter.default.post(name: Notification.Name.Memo.Insert, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
