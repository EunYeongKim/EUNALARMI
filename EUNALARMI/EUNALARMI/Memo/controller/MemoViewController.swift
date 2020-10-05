//
//  MemoViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/23.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController {
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    @IBOutlet weak var memoCollectionView: UICollectionView!
    @IBOutlet weak var memoTableView: UITableView!
    
    override func awakeFromNib() {
        let regularImg = UIImage(systemName: "doc.text")
        let selectedImg = UIImage(systemName: "doc.text.fill")
        let item = UITabBarItem(title: "Memo", image: regularImg, selectedImage: selectedImg)
        
        tabBarItem = item
    }
    
    var token: NSObjectProtocol?
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = NotificationCenter.default.addObserver(forName: Notification.Name.Memo.Insert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.memoCollectionView.reloadData()
            self?.memoTableView.reloadData()
        }
    }

}

extension MemoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Memo.dummyMemoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoCarouselCell", for: indexPath) as! MemoCollectionViewCell
        let target = Memo.dummyMemoList[indexPath.row]
        cell.memo = target

        return cell
    }
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Memo.dummyMemoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
        let target = Memo.dummyMemoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(from: target.createDate)
        
        return cell
    }
}

extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let nav = UIStoryboard(name: "MemoStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MemoDetailViewNavigationController") as? UINavigationController, let vc = nav.viewControllers.first as? MemoDetailViewController else { return }
        vc.memo = Memo.dummyMemoList[indexPath.row]
        
        self.present(nav, animated: true, completion: nil)
    }
}

extension MemoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let nav = UIStoryboard(name: "MemoStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MemoDetailViewNavigationController") as? UINavigationController, let vc = nav.viewControllers.first as? MemoDetailViewController else { return }
        vc.memo = Memo.dummyMemoList[indexPath.row]
        
        self.present(nav, animated: true, completion: nil)
    }
}
