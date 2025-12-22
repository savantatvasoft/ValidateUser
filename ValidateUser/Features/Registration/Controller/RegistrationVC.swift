import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var nameField: InputTextField!
    @IBOutlet weak var emailField: InputTextField!
    @IBOutlet weak var dobField: InputTextField!

    @IBOutlet weak var nameFieldHeigthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var dobFieldHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var emailFieldHeightConstraints: NSLayoutConstraint!
    
    private let datePicker = UIDatePicker()
    
//    private var nameFieldHeightConstraint: NSLayoutConstraint?
//    private var emailHeightConstraint: NSLayoutConstraint?
//    private var dobHeightConstraint: NSLayoutConstraint?

    var isFormValid: Bool {
        guard let name = nameField?.textField.text,
              let email = emailField?.textField.text,
              let dob = dobField?.textField.text else { return false }
              
        return Validator.isValidName(name).isValid &&
               Validator.isValidEmail(email).isValid &&
               !dob.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismis()
        setupConstraints()
    }
    
    private func setupConstraints() {
        //        nameField.translatesAutoresizingMaskIntoConstraints = false
       
//        nameField.translatesAutoresizingMaskIntoConstraints = false
//        nameFieldHeightConstraint = nameField.heightAnchor.constraint(equalToConstant: 40)
//        nameFieldHeightConstraint?.isActive = true
//        
//       
//        emailField.translatesAutoresizingMaskIntoConstraints = false
//        emailHeightConstraint = emailField.heightAnchor.constraint(equalToConstant: 40)
//        emailHeightConstraint?.isActive = true
//        
//       
//        dobField.translatesAutoresizingMaskIntoConstraints = false
//        dobHeightConstraint = dobField.heightAnchor.constraint(equalToConstant: 40)
//        dobHeightConstraint?.isActive = true
    }
    
    private func setupKeyboardDismis() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // Setting this to false ensures that button taps or other
        // interactions still work while the keyboard is up
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupUI() {
        setupDatePicker()
        
        // --- Placeholder Functionality ---
        nameField?.setPlaceholder("Enter Name")
        emailField?.setPlaceholder("Enter Email")
        dobField?.setPlaceholder("DD/MM/YYYY")
        
        // Using compactMap to safely handle any nil outlets
        let fields = [nameField, emailField, dobField].compactMap { $0 }
        
        fields.forEach { field in
            field.textField.delegate = self
            field.textField.addTarget(self, action: #selector(onTyping(_:)), for: .editingChanged)
        }
    }

    @objc private func onTyping(_ textField: UITextField) {
        validate(textField: textField, isSilent: false)
        print("Form Status: \(isFormValid ? "Ready" : "Invalid")")
    }

    private func validate(textField: UITextField, isSilent: Bool) {
        let text = textField.text ?? ""
        
        switch textField {
        case nameField?.textField:
            let result = Validator.isValidName(text)
            let hasError = !isSilent && !result.isValid
            // Safe access using optional chaining
            nameField?.setErrorState(!isSilent && !result.isValid, errorMessage: result.error)
            updateFieldHeight(hasError: hasError)
            
        case emailField?.textField:
            let result = Validator.isValidEmail(text)
            emailField?.setErrorState(!isSilent && !result.isValid, errorMessage: result.error)
            
        case dobField?.textField:
            let isEmpty = text.isEmpty
            dobField?.setErrorState(!isSilent && isEmpty, errorMessage: "Date of birth is required")
            
        default: break
        }
    }
    
    private func updateFieldHeight(hasError: Bool) {
            // When there is an error, we increase the height to fit the label.
            // If you specifically want it shorter (40) on error, change the value below.
            let targetHeight: CGFloat = hasError ? 40 : 40
        
            
            UIView.animate(withDuration: 0.3) {
//                self.nameFieldHeightConstraint?.constant = targetHeight
                self.nameFieldHeigthConstraints.constant = targetHeight
                self.view.layoutIfNeeded()
            }
        }
}

// MARK: - Date Picker & Delegate
extension RegistrationVC: UITextFieldDelegate {
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        toolbar.setItems([cancel, space, done], animated: false)
        
        dobField?.textField.inputView = datePicker
        dobField?.textField.inputAccessoryView = toolbar
    }

    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dobField?.textField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        
        if let textField = dobField?.textField {
            validate(textField: textField, isSilent: false)
        }
    }

    @objc private func cancelPressed() {
        view.endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField?.textField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 20
        }
        return true
    }
}

