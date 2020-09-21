//
//  SettingAlarmLabel.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/17.
//  Copyright © 2020 60080252. All rights reserved.
//

import Foundation

func convertDaysToLabel(_ days: [WeekDay])-> String {
    var resultLabel = ""
    var sortedDay = days.sorted()
    
    var weekday: [WeekDay] = [.mon, .tue, .wed, .thu, .fri]
    var weekend: [WeekDay] = [.sun, .sat]
    
    if days.count == 0 {
        return "안 함"
    } else if days.count == 1 {
        return days[0].getDayInKorean() + "요일마다"
    } else if days.count == 7 {
        return "매일"
    } else if weekday == sortedDay {
        return "주중"
    } else if weekend == sortedDay {
        return "주말"
    } else {
        for day in days {
            resultLabel.append(day.getDayInKorean() + " ")
        }
    }
    
    return resultLabel
}
