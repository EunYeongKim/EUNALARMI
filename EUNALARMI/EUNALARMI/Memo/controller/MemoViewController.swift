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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
