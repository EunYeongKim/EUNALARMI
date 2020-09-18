//
//  AlarmLabelViewController.swift
//  EUNALARMI
//
//  Created by 60080252 on 2020/09/17.
//  Copyright © 2020 60080252. All rights reserved.
//

import UIKit

class AlarmLabelViewController: UIViewController {
    
    @IBOutlet weak var alarmTextField: UITextField!
    weak var settingLabelDelegate: AlarmDetailDelegate?
    var labelValue: String = "알람"
    
    @IBAction func alarmTextFieldDidChanged(_ sender: Any) {
        self.labelValue = alarmTextField.text ?? "알람"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmTextField.returnKeyType = UIReturnKeyType.done
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.alarmTextField.becomeFirstResponder()
        self.alarmTextField.text = self.labelValue
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            settingLabelDelegate?.settingAlarmLabel(self, label: self.labelValue)
        }
    }
}

extension AlarmLabelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        labelValue = textField.text ?? "알람"
        self.navigationController?.popViewController(animated: true)
        return true
    }
}
