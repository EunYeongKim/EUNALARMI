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
    
    weak var alarmDelegate: AlarmMainDelegate?
    var alarmSetting: [AlarmSetting] = AlarmSetting.generateData()
    var alarm: Alarm = Alarm()
    
    var editIndex: Int?
    var dateformatter = DateFormatter()
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSave(_ sender: Any) {
        alarmDelegate?.addAlarmItem(alarm: alarm)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapEdit(_ sender: Any) {
        guard let index = editIndex else { return }
        alarmDelegate?.editAlarmItem(alarm: alarm, index: index)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func timeChanged() {
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        let datetime = dateformatter.string(from: timePicker.date).split(separator: " ").map(String.init)
        self.alarm.alarmTimeLabel = datetime[0]
        self.alarm.alarmApmLabel = datetime[1]
        
        dateformatter.dateFormat = "HH:mm"
        self.alarm.alarmTime = dateformatter.string(from: timePicker.date)
    }
    
    func prepareEditing() {
        if let alarmTime = self.alarm.alarmTime {
            dateformatter.dateFormat = "HH:mm"
            self.timePicker.date = dateformatter.date(from: alarmTime) ?? Date()
        }
        
        alarmSetting[0].detail = convertDaysToString(self.alarm.alarmCycle)
        alarmSetting[1].detail = self.alarm.alarmLabel
    }
    
    func initDataWithView() {
        if editIndex != nil {
            prepareEditing()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(didTapEdit(_:)))
        } else {
            timeChanged()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSave(_:)))
        }
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 165/255, green: 147/255, blue: 224/255, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataWithView()
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
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
        alarmSetting[0].detail = convertDaysToString(value)
        settingTableView.reloadData()
    }
}

