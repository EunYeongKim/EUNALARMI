//
//  MemoViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/23.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController {
    let collectionViewStaticCount = 3
    var tableViewIndexCount = 0
    var memoList: [Memo] {
        get {
            return UserDefaults.standard.arrayModelData(by: "memoList", type: Memo.self)
        }
        set {
            UserDefaults.standard.setArrayModel(by: "memoList", newValue: newValue)
        }
    }
    
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    var insertMemoToken: NSObjectProtocol?
    var editMemoToken: NSObjectProtocol?

    @IBOutlet weak var memoCollectionView: UICollectionView!
    @IBOutlet weak var memoTableView: UITableView!
    
    override func awakeFromNib() {
        let regularImg = UIImage(systemName: "doc.text")
        let selectedImg = UIImage(systemName: "doc.text.fill")
        let item = UITabBarItem(title: "Memo", image: regularImg, selectedImage: selectedImg)
        
        tabBarItem = item
    }
    
    deinit {
        if let token = insertMemoToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = editMemoToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func configureUI(){
        if memoList.count < collectionViewStaticCount {
            tableViewIndexCount = 0
            memoCollectionView.isHidden = true
        } else {
            tableViewIndexCount = collectionViewStaticCount
            memoCollectionView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        insertMemoToken = NotificationCenter.default.addObserver(forName: Notification.Name.Memo.Insert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            guard let `self` = self else { return }
            if let newMemo = noti.userInfo?["memo"] as? Memo {
                self.memoList.append(newMemo)
            }
            self.configureUI()
            self.memoCollectionView.reloadData()
            self.memoTableView.reloadData()
        }
        
        editMemoToken = NotificationCenter.default.addObserver(forName: Notification.Name.Memo.Edit, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            guard let `self` = self else { return }
            if let editMemo = noti.userInfo?["memo"] as? Memo, let index = noti.userInfo?["index"] as? Int {
                self.memoList[index] = editMemo
            }
            self.memoCollectionView.reloadData()
            self.memoTableView.reloadData()
        }
    }

}

extension MemoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableViewIndexCount == 0 ? memoList.count : collectionViewStaticCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoCarouselCell", for: indexPath) as! MemoCollectionViewCell
        let target = memoList[indexPath.row]
        cell.memo = target

        return cell
    }
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count - tableViewIndexCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
        if tableViewIndexCount + indexPath.row <= memoList.count {
            let target = memoList[tableViewIndexCount + indexPath.row]
            cell.textLabel?.text = target.content
            cell.detailTextLabel?.text = formatter.string(from: target.createDate)
        }
        
        return cell
    }
}

extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let nav = UIStoryboard(name: "MemoStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MemoDetailViewNavigationController") as? UINavigationController, let vc = nav.viewControllers.first as? MemoDetailViewController, tableViewIndexCount + indexPath.row <= memoList.count else { return }
        vc.memo = memoList[tableViewIndexCount + indexPath.row]
        vc.memoIndex = tableViewIndexCount + indexPath.row
        
        self.present(nav, animated: true, completion: nil)
    }
}

extension MemoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let nav = UIStoryboard(name: "MemoStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MemoDetailViewNavigationController") as? UINavigationController, let vc = nav.viewControllers.first as? MemoDetailViewController else { return }
        vc.memo = memoList[indexPath.row]
        vc.memoIndex = indexPath.row
        
        self.present(nav, animated: true, completion: nil)
    }
}
