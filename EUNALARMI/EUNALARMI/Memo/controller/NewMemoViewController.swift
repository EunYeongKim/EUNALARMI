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
    var originalMemoContent: String?
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
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
            originalMemoContent = editMemo?.content
        }
    }
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func registerObserver() {
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let `self` = self else { return }
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = frame.cgRectValue.height
                
                var inset = self.memoTextView.contentInset
                inset.bottom = keyboardHeight
                self.memoTextView.contentInset = inset
                
                inset = self.memoTextView.scrollIndicatorInsets
                inset.bottom = keyboardHeight
                self.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let `self` = self else { return }
            
            var inset = self.memoTextView.contentInset
            inset.bottom = 0
            self.memoTextView.contentInset = inset
            
            inset = self.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            self.memoTextView.scrollIndicatorInsets = inset
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        memoTextView.delegate = self
        registerObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.becomeFirstResponder()
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        memoTextView.resignFirstResponder()
        navigationController?.presentationController?.delegate = nil
    }
    
    func editSaveAlert() {
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.didTapSave(action)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.didTapClose(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension NewMemoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            }
        }
    }
}

extension NewMemoViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        editSaveAlert()
    }
}
