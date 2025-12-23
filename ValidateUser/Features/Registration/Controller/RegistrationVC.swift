import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var username: InputField!
    @IBOutlet weak var userEmail: InputField!
    @IBOutlet weak var userdob: InputField!
    @IBOutlet weak var userPhonenumber: InputField!
    @IBOutlet weak var linkedinUrl: InputField!
    
    // TextView and Placeholder
    @IBOutlet weak var userDescriptionTextView: UITextView!
    @IBOutlet weak var descriptionPlaceholderLabel: UILabel!
    
    private let datePicker = UIDatePicker()

    var isFormValid: Bool {
        guard let name = username.textField.text,
              let email = userEmail.textField.text,
              let dob = userdob.textField.text,
              let phone = userPhonenumber.textField.text else { return false }
              
        return Validator.isValidName(name).isValid &&
               Validator.isValidEmail(email).isValid &&
               Validator.isValidMobile(phone).isValid &&
               !dob.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismiss()
    }

    private func setupUI() {
        // Correctly calling the date picker setup
        setupDatePicker()
        
        username.setPlaceholder("Enter Name")
        userEmail.setPlaceholder("Enter Email")
        userdob.setPlaceholder("DD/MM/YYYY")
        userPhonenumber.setPlaceholder("Enter 10-digit mobile number")
        userPhonenumber.textField.keyboardType = .numberPad
        
        linkedinUrl.setPlaceholder("LinkedIn Profile URL")
        linkedinUrl.textField.keyboardType = .URL
        linkedinUrl.textField.autocapitalizationType = .none
        linkedinUrl.setLeftImage(UIImage(named: "linked_In"))
        
        // Setup TextView Delegate and initial state
        userDescriptionTextView.delegate = self
        userDescriptionTextView.isScrollEnabled = false
        updatePlaceholderVisibility()
        
        // Setup Delegates for InputFields
        let fields = [username, userEmail, userdob, userPhonenumber, linkedinUrl].compactMap { $0 }
        fields.forEach { field in
            field.textField.delegate = self
            field.textField.addTarget(self, action: #selector(onTyping(_:)), for: .editingChanged)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
        linkedinUrl.addGestureRecognizer(tap)
    }
    
    // Simplifies placeholder logic based on text and focus
    private func updatePlaceholderVisibility() {
        let shouldHide = !userDescriptionTextView.text.isEmpty || userDescriptionTextView.isFirstResponder
        descriptionPlaceholderLabel.isHidden = shouldHide
    }
    
    // Standard Date Picker Setup with simplified Toolbar
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        // Simple white toolbar with no extra styling
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = .white
        toolbar.isTranslucent = false
        toolbar.backgroundColor = .white
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        
        toolbar.setItems([cancel, space, done], animated: false)
        
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
        case userPhonenumber.textField:
            let result = Validator.isValidMobile(text)
            userPhonenumber.setErrorState(!isSilent && !result.isValid, errorMessage: result.error)
        case userdob.textField:
            userdob.setErrorState(!isSilent && text.isEmpty, errorMessage: "Date of birth is required")
        case linkedinUrl.textField:
            let result = Validator.isValidURL(text)
            linkedinUrl.setErrorState(!isSilent && !result, errorMessage: result ? nil : "Invalid LinkedIn URL")
            linkedinUrl.setAsLink(result)
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
    
    @objc private func handleLinkTap() {
        guard let urlString = linkedinUrl.textField.text, !urlString.isEmpty else { return }
        if Validator.isValidURL(urlString), let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - Delegates
extension RegistrationVC: UITextFieldDelegate, UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        
        // Handles auto-growth of the container view
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.isScrollEnabled = estimatedSize.height > 180
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == username.textField { return prospectiveText.count <= 20 }
        if textField == userPhonenumber.textField {
            let allowedCharacters = CharacterSet.decimalDigits
            return CharacterSet(charactersIn: string).isSubset(of: allowedCharacters) && prospectiveText.count <= 10
        }
        return true
    }
}
