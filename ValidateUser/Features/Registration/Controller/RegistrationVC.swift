import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var username: InputField!
    
    @IBOutlet weak var userEmail: InputField!
    @IBOutlet weak var userdob: InputField!

    private let datePicker = UIDatePicker()

    var isFormValid: Bool {
        guard let name = username.textField.text,
              let email = userEmail.textField.text,
              let dob = userdob.textField.text else { return false }
              
        return Validator.isValidName(name).isValid &&
               Validator.isValidEmail(email).isValid &&
               !dob.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismiss()
    
    }

    private func setupUI() {
        setupDatePicker()
        
        // 1. Setup Placeholders
        username.setPlaceholder("Enter Name")
        userEmail.setPlaceholder("Enter Email")
        userdob.setPlaceholder("DD/MM/YYYY")
        
        // 2. Setup Delegates and Target actions
        let fields = [username, userEmail, userdob].compactMap { $0 }
        fields.forEach { field in
            field.textField.delegate = self
            field.textField.addTarget(self, action: #selector(onTyping(_:)), for: .editingChanged)
        }
    }

    @objc private func onTyping(_ textField: UITextField) {
        validate(textField: textField, isSilent: false)
    }

    private func validate(textField: UITextField, isSilent: Bool) {
        let text = textField.text ?? ""
        
        switch textField {
        case username.textField:
            let result = Validator.isValidName(text)
            username.setErrorState(!isSilent && !result.isValid, errorMessage: result.error)
            
        case userEmail.textField:
            let result = Validator.isValidEmail(text)
            userEmail.setErrorState(!isSilent && !result.isValid, errorMessage: result.error)
            
        case userdob.textField:
            let isEmpty = text.isEmpty
            userdob.setErrorState(!isSilent && isEmpty, errorMessage: "Date of birth is required")
            
        default: break
        }
    }

    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Date Picker & Delegate
extension RegistrationVC: UITextFieldDelegate {
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        // Create the toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .systemBlue // Standard Apple Blue
        
        // Create Buttons
        // 'Cancel' on the left (Leading)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        // Flexible space to push buttons to the edges
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 'Done' on the right (Trailing)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        
        // Apply items to toolbar
        toolbar.setItems([cancel, space, done], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Assign to the text field
        userdob.textField.inputView = datePicker
        userdob.textField.inputAccessoryView = toolbar
    }

    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        userdob.textField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        validate(textField: userdob.textField, isSilent: false)
    }

    @objc private func cancelPressed() {
        view.endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == username.textField {
            let currentText = textField.text ?? ""
            return (currentText.count + string.count - range.length) <= 20
        }
        return true
    }
}




