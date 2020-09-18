//
//  AlarmWeekDayTableViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/17.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class AlarmWeekDayTableViewController: UITableViewController {
    
    @IBOutlet var weekDayTableView: UITableView!
    weak var settingCycleDelegate: AlarmDetailDelegate?
    var days: [WeekDay] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekDayTableView.allowsMultipleSelection = true
    }
 
    override func willMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if parent == nil {
           guard let selectedRows = weekDayTableView.indexPathsForSelectedRows else { return }
            self.days = []
            for indexPath in selectedRows {
                if let week = WeekDay.init(rawValue: indexPath.row) {
                 days.append(week)
                }
            }
            settingCycleDelegate?.settingAlarmCycle(self, days: days.sorted())
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekDayCell", for: indexPath)
        
        if let day = WeekDay.init(rawValue: indexPath.row) {
            cell.textLabel?.text =  day.getDayInKorean() + "요일마다"
            if days.contains(day) {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
    
}
