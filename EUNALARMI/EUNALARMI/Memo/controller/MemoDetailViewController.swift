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
