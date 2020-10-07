//
//  AlarmViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/16.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    var alarmList: [Alarm] {
        get {
            return UserDefaults.standard.arrayModelData(by: "alarmList", type: Alarm.self)
        }
        set {
            UserDefaults.standard.setArrayModel(by: "alarmList", newValue: newValue)
        }
    }
    @IBOutlet weak var alarmTableView: UITableView!
    
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
        vc.alarmDelegate = self
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        alarmList[sender.tag].alarmOn = sender.isOn
        if sender.isOn {
            setNotification(alarm: alarmList[sender.tag])
        } else {
            deleteNotification(alarm: alarmList[sender.tag])
        }
    }
    
    func setNotification(alarm: Alarm) {
        let manager = AlarmNotificationManager()
        manager.addAlarmNotification(alarm: alarm)
        manager.scheduleAlarm()
    }
    
    func deleteNotification(alarm: Alarm) {
        let manager = AlarmNotificationManager()
        manager.removeAlarmNotification(alarm: alarm)
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

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "편집", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            guard let vc = UIStoryboard(name: "AlarmStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewAlarmViewController") as? NewAlarmViewController else { return }
            let nav = UINavigationController(rootViewController: vc)
            
            self.deleteNotification(alarm: self.alarmList[indexPath.row])
            
            vc.alarmDelegate = self
            vc.alarm = self.alarmList[indexPath.row]
            vc.editIndex = indexPath.row
            
            self.present(nav, animated: true, completion: nil)
            
            success(true)
        })
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.deleteNotification(alarm: self.alarmList[indexPath.row])
            self.alarmList.remove(at: indexPath.row)
            
            self.alarmTableView.beginUpdates()
            self.alarmTableView.deleteRows(at: [indexPath], with: .automatic)
            self.alarmTableView.endUpdates()
            
            success(true)
        })
        
        return UISwipeActionsConfiguration(actions:[deleteAction, editAction])
    }
}

extension AlarmViewController: AlarmMainDelegate {
    func addAlarmItem(alarm value: Alarm) {
        alarmList.append(value)
        setNotification(alarm: value)
        alarmTableView.reloadData()
    }
    
    func editAlarmItem(alarm value: Alarm, index: Int) {
        alarmList[index] = value
        setNotification(alarm: value)
        alarmTableView.reloadData()
    }
}

