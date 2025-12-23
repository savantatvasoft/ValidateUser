import UIKit

class RegistrationVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var username: InputField!
    @IBOutlet weak var userEmail: InputField!
    @IBOutlet weak var userdob: InputField!
    @IBOutlet weak var userPhonenumber: InputField!
    @IBOutlet weak var linkedinUrl: InputField!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var userDescriptionTextView: UITextView!
    @IBOutlet weak var descriptionPlaceholderLabel: UILabel!
    
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var checkButtonView: UIButton!
    @IBOutlet weak var registerButttonView: UIButton!
    
    // MARK: - Properties
    private let viewModel = RegistrationViewModel()
    private let datePicker = UIDatePicker()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismiss()
        setupKeyboardObservers()
    }
    
    deinit {
            // Best practice: remove observers when VC is destroyed
            NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupDatePicker()
        setupAgreementLabel()
        configureInputFields()
        updateRegisterButtonState()
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configureInputFields() {
        username.setPlaceholder("Enter Name")
        userEmail.setPlaceholder("Enter Email")
        userdob.setPlaceholder("DD/MM/YYYY")
        userPhonenumber.setPlaceholder("Enter 10-digit mobile number")
        userPhonenumber.textField.keyboardType = .numberPad
        
        linkedinUrl.setPlaceholder("LinkedIn Profile URL")
        linkedinUrl.textField.keyboardType = .URL
        linkedinUrl.textField.autocapitalizationType = .none
        linkedinUrl.setLeftImage(UIImage(named: "linked_In"))
        
        userDescriptionTextView.delegate = self
        userDescriptionTextView.isScrollEnabled = false
        updatePlaceholderVisibility()
        
        let fields = [username, userEmail, userdob, userPhonenumber, linkedinUrl].compactMap { $0 }
        fields.forEach { field in
            field.textField.delegate = self
            field.textField.addTarget(self, action: #selector(onTyping(_:)), for: .editingChanged)
        }
        
        linkedinUrl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLinkTap)))
    }

    // MARK: - Actions
    @objc private func onTyping(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        // Sync View -> ViewModel
        switch textField {
        case username.textField: viewModel.user.name = text
        case userEmail.textField: viewModel.user.email = text
        case userPhonenumber.textField: viewModel.user.phone = text
        case linkedinUrl.textField: viewModel.user.linkedinUrl = text
        default: break
        }
        
        validate(textField: textField, isSilent: false)
        updateRegisterButtonState()
    }

    @IBAction func onPressCheckButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.user.isTermsAccepted = sender.isSelected // Sync to VM
        
        let imageName = sender.isSelected ? "Tick_Blue" : "square"
        sender.setImage(UIImage(named: imageName), for: .normal)
        
        updateRegisterButtonState()
    }
    
    @IBAction func onPressRegister(_ sender: UIButton) {
        print("Registering User: \(viewModel.user.name)")
    }

    // MARK: - UI Logic
    private func updateRegisterButtonState() {
        let isValid = viewModel.isFormValid
        registerButttonView.isEnabled = isValid
        
        // Smoothly adjust opacity and ensure text color
        UIView.animate(withDuration: 0.2) {
            self.registerButttonView.alpha = isValid ? 1.0 : 0.5
            
            // Ensure text stays white regardless of state
            if var config = self.registerButttonView.configuration {
                config.baseForegroundColor = .white
                self.registerButttonView.configuration = config
            } else {
                // Fallback for legacy buttons
                self.registerButttonView.setTitleColor(.white, for: .normal)
                self.registerButttonView.setTitleColor(.white, for: .disabled)
            }
        }
    }

    private func setupAgreementLabel() {
        let fullText = "I agree to the Terms and Conditions"
        let linkText = "Terms and Conditions"
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: linkText)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: range)
        }
        
        agreementLabel.attributedText = attributedString
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTermsTap(_:))))
    }

    // MARK: - Helper Methods
    private func validate(textField: UITextField, isSilent: Bool) {
        let text = textField.text ?? ""
        switch textField {
        case username.textField:
            username.setErrorState(!isSilent && !Validator.isValidName(text).isValid, errorMessage: Validator.isValidName(text).error)
        case userEmail.textField:
            userEmail.setErrorState(!isSilent && !Validator.isValidEmail(text).isValid, errorMessage: Validator.isValidEmail(text).error)
        case userPhonenumber.textField:
            userPhonenumber.setErrorState(!isSilent && !Validator.isValidMobile(text).isValid, errorMessage: Validator.isValidMobile(text).error)
        case userdob.textField:
            userdob.setErrorState(!isSilent && text.isEmpty, errorMessage: "Date of birth is required")
        case linkedinUrl.textField:
            let result = Validator.isValidURL(text)
            linkedinUrl.setErrorState(!isSilent && !result, errorMessage: result ? nil : "Invalid LinkedIn URL")
            linkedinUrl.setAsLink(result)
        default: break
        }
    }

    // MARK: - Date Picker
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done], animated: false)
        
        userdob.textField.inputView = datePicker
        userdob.textField.inputAccessoryView = toolbar
    }

    @objc private func donePressed() {
        let dateString = viewModel.formatDate(datePicker.date)
        userdob.textField.text = dateString
        viewModel.user.dob = dateString // Sync to VM
        
        view.endEditing(true)
        validate(textField: userdob.textField, isSilent: false)
        updateRegisterButtonState()
    }

    private func updatePlaceholderVisibility() {
        descriptionPlaceholderLabel.isHidden = !userDescriptionTextView.text.isEmpty || userDescriptionTextView.isFirstResponder
    }
    
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    @objc private func handleTermsTap(_ gesture: UITapGestureRecognizer) {
        let range = (agreementLabel.text! as NSString).range(of: "Terms and Conditions")
        if gesture.didTapAttributedTextInLabel(label: agreementLabel, inRange: range) {
            if let url = URL(string: "https://www.google.com") { UIApplication.shared.open(url) }
        }
    }
    
    @objc private func handleLinkTap() {
        if let urlStr = linkedinUrl.textField.text, let url = URL(string: urlStr) {
            UIApplication.shared.open(url)
        }
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            // Add bottom inset to scrollview so content can be scrolled up
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollview.contentInset = contentInsets
            scrollview.scrollIndicatorInsets = contentInsets
        }

        @objc private func keyboardWillHide(notification: NSNotification) {
            // Reset scrollview insets to zero
            let contentInsets = UIEdgeInsets.zero
            scrollview.contentInset = contentInsets
            scrollview.scrollIndicatorInsets = contentInsets
        }
}

// MARK: - Delegates
extension RegistrationVC: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            // NEW: Automatically scroll to the active field
            let rect = textField.convert(textField.bounds, to: scrollview)
            scrollview.scrollRectToVisible(rect, animated: true)
        }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.user.description = textView.text // Sync to VM
        updatePlaceholderVisibility()
        self.view.layoutIfNeeded()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == userPhonenumber.textField { return prospectiveText.count <= 10 }
        return true
    }
}
