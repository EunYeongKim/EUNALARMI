//
//  MemoDetailViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/25.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class MemoDetailViewController: UIViewController {
    var memo: Memo?
    var memoIndex: Int?
    var editMemoToken: NSObjectProtocol?
    
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    @IBOutlet weak var memoContentTableView: UITableView!
    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapDelete(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (action) in
            self?.deleteMemoNoti()
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteMemoNoti() {
        guard let deleteMemo = memo, let index = memoIndex else { return }
        let userInfo = ["memo": deleteMemo, "index": index] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name.Memo.Delete, object: nil, userInfo: userInfo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? NewMemoViewController {
            vc.editMemo = memo
            vc.memoIndex = memoIndex
        }
    }
    
    deinit {
        if let token = editMemoToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editMemoToken = NotificationCenter.default.addObserver(forName: Notification.Name.Memo.Edit, object: nil, queue: OperationQueue.main) { [weak self] (_) in
            self?.memoContentTableView.reloadData()
        }
    }
}

extension MemoDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
            cell.textLabel?.text = memo?.content
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = formatter.string(for: memo?.createDate)
            return cell
        default:
            fatalError()
        }
    }
}
