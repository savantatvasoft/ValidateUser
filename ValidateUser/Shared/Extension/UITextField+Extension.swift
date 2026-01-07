//
//  UITextField+Extension.swift
//  ValidateUser
//
//  Created by MACM72 on 02/01/26.
//

import Foundation
import UIKit

extension UITextField {
    func setupDatePicker(target: Any, doneAction: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        self.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "reg_done".localized,
            style: .plain,
            target: target,
            action: doneAction
        )
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        self.inputAccessoryView = toolbar
    }
}
