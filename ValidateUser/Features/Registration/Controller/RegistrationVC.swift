import UIKit

class RegistrationVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var username: InputField!
    @IBOutlet weak var userEmail: InputField!
    @IBOutlet weak var userdob: InputField!
    @IBOutlet weak var userPhonenumber: InputField!
    @IBOutlet weak var linkedinUrl: InputField!
    
    @IBOutlet weak var userDescriptionTextView: UITextView!
    @IBOutlet weak var descriptionPlaceholderLabel: UILabel!
    
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var checkButtonView: UIButton!
    @IBOutlet weak var registerButttonView: UIButton!
    
    // MARK: - Properties
    private let datePicker = UIDatePicker()

    /// Computed property to check if the entire form is ready for submission
    var isFormValid: Bool {
        guard let name = username.textField.text,
              let email = userEmail.textField.text,
              let dob = userdob.textField.text,
              let phone = userPhonenumber.textField.text,
              let linkedin = linkedinUrl.textField.text else { return false }
              
        return Validator.isValidName(name).isValid &&
               Validator.isValidEmail(email).isValid &&
               Validator.isValidMobile(phone).isValid &&
               Validator.isValidURL(linkedin) &&
               !dob.isEmpty &&
               checkButtonView.isSelected // Requirement: Terms must be accepted
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismiss()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        setupDatePicker()
        setupAgreementLabel()
        
        // Configure InputFields
        username.setPlaceholder("Enter Name")
        userEmail.setPlaceholder("Enter Email")
        userdob.setPlaceholder("DD/MM/YYYY")
        userPhonenumber.setPlaceholder("Enter 10-digit mobile number")
        userPhonenumber.textField.keyboardType = .numberPad
        
        linkedinUrl.setPlaceholder("LinkedIn Profile URL")
        linkedinUrl.textField.keyboardType = .URL
        linkedinUrl.textField.autocapitalizationType = .none
        linkedinUrl.setLeftImage(UIImage(named: "linked_In"))
        
        // Setup TextView
        userDescriptionTextView.delegate = self
        userDescriptionTextView.isScrollEnabled = false
        updatePlaceholderVisibility()
        
        // Setup Delegates and Validation Observers
        let fields = [username, userEmail, userdob, userPhonenumber, linkedinUrl].compactMap { $0 }
        fields.forEach { field in
            field.textField.delegate = self
            field.textField.addTarget(self, action: #selector(onTyping(_:)), for: .editingChanged)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
        linkedinUrl.addGestureRecognizer(tap)
        
        // Initial Button State
        updateRegisterButtonState()
    }

    // MARK: - Actions
    @IBAction func onPressCheckButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        let imageName = sender.isSelected ? "Tick_Blue" : "square"
        sender.setImage(UIImage(named: imageName), for: .normal)
        
        updateRegisterButtonState()
    }
    
    @IBAction func onPressRegister(_ sender: UIButton) {
        guard isFormValid else { return }
        print("Form Submitted Successfully!")
        // Proceed with registration logic
    }

    @objc private func onTyping(_ textField: UITextField) {
        validate(textField: textField, isSilent: false)
        updateRegisterButtonState()
    }

    // MARK: - UI Logic
    private func updateRegisterButtonState() {
        let isValid = isFormValid
        registerButttonView.isEnabled = isValid
        
        // Smoothly adjust opacity to show "faded" or "active" state
        UIView.animate(withDuration: 0.2) {
            self.registerButttonView.alpha = isValid ? 1.0 : 0.5
        }
    }

    private func updatePlaceholderVisibility() {
        let shouldHide = !userDescriptionTextView.text.isEmpty || userDescriptionTextView.isFirstResponder
        descriptionPlaceholderLabel.isHidden = shouldHide
    }

    private func setupAgreementLabel() {
        let fullText = "I agree to the Terms and Conditions"
        let linkText = "Terms and Conditions"
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: linkText)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: agreementLabel.font.pointSize), range: range)
        }
        
        agreementLabel.attributedText = attributedString
        agreementLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermsTap(_:)))
        agreementLabel.addGestureRecognizer(tap)
    }

    // MARK: - Helper Methods
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

    @objc private func handleTermsTap(_ gesture: UITapGestureRecognizer) {
        let linkText = "Terms and Conditions"
        let range = (agreementLabel.text! as NSString).range(of: linkText)
        if gesture.didTapAttributedTextInLabel(label: agreementLabel, inRange: range) {
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url)
            }
        }
    }

    // MARK: - Date Picker Logic
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = .white
        
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
        updateRegisterButtonState()
    }

    @objc private func cancelPressed() {
        view.endEditing(true)
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
            UIApplication.shared.open(url)
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

// MARK: - Tap Gesture Extension
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(
            x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
