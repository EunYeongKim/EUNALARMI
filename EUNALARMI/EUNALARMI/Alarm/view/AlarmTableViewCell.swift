//
//  AlarmTableViewCell.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/16.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmAPM: UILabel!
    @IBOutlet weak var alarmCycle: UILabel!
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!

    var alarm: Alarm? {
        didSet {
            guard let alarmTmp = alarm else { return }
            self.alarmAPM.text = alarmTmp.alarmApmLabel
            if alarmTmp.alarmCycle.count == 0 {
                self.alarmCycle.text = alarmTmp.alarmLabel
            } else {
                self.alarmCycle.text = alarmTmp.alarmLabel + "  " + convertDaysToString(alarmTmp.alarmCycle)
            }
            self.alarmTime.text = alarmTmp.alarmTimeLabel
            self.alarmSwitch.isOn = alarmTmp.alarmOn
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
