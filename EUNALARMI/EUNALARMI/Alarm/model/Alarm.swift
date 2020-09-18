//
//  Alarm.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/16.
//  Copyright © 2020 60080252. All rights reserved.
//

import Foundation

struct Alarm {
    var alarmAPM: String?
    var alarmLabel: String = "알람"
    var alarmCycle: [WeekDay] = []
    var alarmTime: String?
    var alarmOn: Bool = true
}

struct AlarmSetting {
    var title: String
    var detail: String
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
    
    static func generateData() -> [AlarmSetting] {
        return [AlarmSetting(title: "반복", detail: "안 함"), AlarmSetting(title: "레이블", detail: "알람")]
    }
}

enum WeekDay: Int, CaseIterable, Comparable {
    static func < (lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case sun, mon, tue, wed, thu, fri, sat
    
    func getDayInKorean() -> String {
        switch self {
        case .mon:
            return "월"
        case .tue:
            return "화"
        case .wed:
            return "수"
        case .thu:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        case .sun:
            return "일"
        }
    }
}

