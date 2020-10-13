//
//  LocalNotificationManager.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/10/07.
//  Copyright © 2020 60080252. All rights reserved.
//

import Foundation
import UserNotifications

struct AlarmNotification {
    var id: String
    var title: String
    var body: String
    var hour: Int
    var minute: Int
    var weekday: Int?
}

class AlarmNotificationManager {
    var alarmNotifications = [AlarmNotification]()
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted == true && error == nil {
                    // permission
                }
            }
    }
    
    func scheduleAlarm() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleAlarmNotifications()
            default:
                break
            }
        }
    }
    
    func addAlarmNotification(alarm: Alarm) -> Void {
        let time = alarm.alarmTime.split(separator: ":")
        guard let hour = Int(time[0]), let minute = Int(time[1]) else { return }
        
        if alarm.alarmCycle.count == 0 {
            alarmNotifications.append(AlarmNotification(id: alarm.alarmNotiId, title: alarm.alarmLabel, body: alarm.alarmTimeLabel, hour: hour, minute: minute, weekday: nil))
        } else {
            for day in alarm.alarmCycle {
                alarmNotifications.append(AlarmNotification(id: alarm.alarmNotiId + String(day.rawValue), title: alarm.alarmLabel, body: alarm.alarmTimeLabel, hour: hour, minute: minute, weekday: day.rawValue + 1))
            }
        }
    }
    
    func removeAlarmNotification(alarm: Alarm) -> Void {
        let notiIdList = alarm.alarmCycle.map({ (weekday: WeekDay) -> (String) in
            return alarm.alarmNotiId + String(weekday.rawValue)
        })
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notiIdList)
    }
    
    func scheduleAlarmNotifications() -> Void {
        for notification in alarmNotifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default
            
            var repeatFlag = false
            var date = DateComponents()
            date.hour = notification.hour
            date.minute = notification.minute
            if let day = notification.weekday {
                date.weekday = day
                repeatFlag = true
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeatFlag)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
