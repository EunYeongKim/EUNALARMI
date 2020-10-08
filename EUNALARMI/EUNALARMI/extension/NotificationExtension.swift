//
//  NotificationExtension.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/25.
//  Copyright © 2020 60080252. All rights reserved.
//

import Foundation

extension Notification.Name {
    enum Memo {
        static let Insert = Notification.Name(rawValue: "Insert")
        static let Edit = Notification.Name(rawValue: "Edit")
        static let Delete = Notification.Name(rawValue: "Delete")
    }
}

