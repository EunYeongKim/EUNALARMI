//
//  AlarmViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/16.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    var alarmList: [Alarm] = []
    @IBOutlet weak var alarmTableView: UITableView!
    
    @IBAction func modifyAlarm(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        let regularImg = UIImage(systemName: "clock")
        let selectedImg = UIImage(systemName: "clock.fill")
        let item = UITabBarItem(title: "Alarm", image: regularImg, selectedImage: selectedImg)
        
        tabBarItem = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? NewAlarmViewController else { return }
        vc.addAlarmDelegate = self
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        alarmList[sender.tag].alarmOn = sender.isOn
    }
}

extension AlarmViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! AlarmTableViewCell
        
        cell.alarmSwitch.tag = indexPath.row
        cell.alarmSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.alarm = alarmList[indexPath.row]
        
        return cell
    }
}

extension AlarmViewController: AlarmMainDelegate {
    func addAlarmItem(_ vc: UIViewController, alarm value: Alarm) {
        alarmList.append(value)
        alarmTableView.reloadData()
    }
}

