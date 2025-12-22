//
//  RegistrationVC.swift
//  ValidateUser
//
//  Created by MACM72 on 19/12/25.
//

import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var nameField: InputTextField!
    @IBOutlet weak var dobField: InputTextField!

    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ RegistrationVC has loaded successfully!")
        setupDatePicker()
            
        // Set delegates to listen for changes
        nameField.textField.delegate = self
        dobField.textField.delegate = self
    }

    func setupDatePicker() {
        dobField.textField.tintColor = .clear // Hides the blinking cursor
        dobField.textField.spellCheckingType = .no
        dobField.textField.autocorrectionType = .no
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        // Setup Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done Button
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        
        // Flexible Space (pushes buttons to the sides)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Cancel Button
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        // Add buttons to toolbar
        toolbar.setItems([cancelBtn, flexSpace, doneBtn], animated: true)
        
        dobField.textField.inputAccessoryView = toolbar
        dobField.textField.inputView = datePicker
    }

    @objc func cancelPressed() {
        self.view.endEditing(true) // Simply close without saving
    }


    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy"
            
        dobField.textField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true) // Close picker
    }
    
    @IBAction func onPressAddPhotot(_ sender: Any) {
        print("tabbed heree")
    }
   
    
    func validateForm() -> Bool {
        // 1. Validate Name
        let nameResult = Validator.isValidName(nameField.textField.text)
        nameField.setErrorState(!nameResult.isValid)
        
        // 2. Validate DOB
        let dobText = dobField.textField.text ?? ""
        let isDobValid = !dobText.isEmpty
        dobField.setErrorState(!isDobValid)
        
        // Check if either is invalid
        if !nameResult.isValid {
            print("❌ Name Error: \(nameResult.error ?? "")")
            return false
        }
        
        if !isDobValid {
            print("❌ DOB Error: Please select a date")
            return false
        }
        
        return true
    }

}

extension RegistrationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji { return false }

        if textField == nameField.textField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 10
        }

        // DOB Field: Absolutely no typing allowed
        if textField == dobField.textField {
            return false
        }
        return true
    }

    // Prevents "Copy/Paste" menu from appearing on DOB field
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobField.textField {
            // Optional: Reset any error state when user opens picker
            dobField.setErrorState(false)
        }
        return true
    }
}
