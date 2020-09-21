//
//  NewAlarmViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/16.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class NewAlarmViewController: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var settingTableView: UITableView!
    
    weak var addAlarmDelegate: AlarmMainDelegate?
    var alarmSetting: [AlarmSetting] = AlarmSetting.generateData()
    var alarm: Alarm = Alarm()
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        addAlarmDelegate?.addAlarmItem(self, alarm: alarm)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func timeChanged() {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        
        let datetime = dateformatter.string(from: timePicker.date).split(separator: " ").map(String.init)
        self.alarm.alarmTime = datetime[0]
        self.alarm.alarmAPM = datetime[1]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        timeChanged()
    }
}

extension NewAlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.text = alarmSetting[indexPath.row].title
        cell.detailTextLabel?.text = alarmSetting[indexPath.row].detail
        
        return cell
    }
}

extension NewAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0) {
            guard let vc = UIStoryboard(name: "AlarmStoryboard", bundle: nil).instantiateViewController(withIdentifier: "AlarmWeekDayTableViewController") as? AlarmWeekDayTableViewController else { return }
            vc.settingCycleDelegate = self
            vc.days = alarm.alarmCycle
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else if(indexPath.row == 1) {
            guard let vc = UIStoryboard(name: "AlarmStoryboard", bundle: nil).instantiateViewController(withIdentifier: "AlarmLabelViewController") as? AlarmLabelViewController else { return }
            vc.settingLabelDelegate = self
            vc.labelValue = alarm.alarmLabel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NewAlarmViewController: AlarmDetailDelegate {
    func settingAlarmLabel(_ vc: UIViewController, label value: String) {
        alarm.alarmLabel = value
        alarmSetting[1].detail = value
        settingTableView.reloadData()
    }
    
    func settingAlarmCycle(_ vc: UIViewController, days value: [WeekDay]) {
        alarm.alarmCycle = value
        alarmSetting[0].detail = convertDaysToLabel(value)
        settingTableView.reloadData()
    }
}

