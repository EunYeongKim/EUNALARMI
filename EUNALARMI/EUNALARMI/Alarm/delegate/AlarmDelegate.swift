
//
//  File.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/18.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

protocol AlarmDetailDelegate: class {
    func settingAlarmCycle(_ vc: UIViewController, days value: [WeekDay]) -> Void
    func settingAlarmLabel(_ vc: UIViewController, label value: String) -> Void
}

protocol AlarmMainDelegate: class {
    func addAlarmItem(alarm value: Alarm) -> Void
    func editAlarmItem(alarm value: Alarm, index: Int) -> Void
}
