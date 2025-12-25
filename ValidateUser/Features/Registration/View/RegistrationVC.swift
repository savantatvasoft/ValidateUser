import UIKit
import PhotosUI
import SafariServices

class RegistrationVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bringSubviewToFront(addPhotoBtn)
    }
    
    deinit {
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
        username.setPlaceholder("reg_ph_name".localized)
        userEmail.setPlaceholder("reg_ph_email".localized)
        userdob.setPlaceholder("reg_ph_dob".localized)
        userPhonenumber.setPlaceholder("reg_ph_phone".localized)
        linkedinUrl.setPlaceholder("reg_ph_linkedin".localized)
        
        userPhonenumber.textField.keyboardType = .numberPad
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

    @IBAction func onAddImage(_ sender: UIButton) {
        showImageSourceOptions()
    }

    @IBAction func onPressCheckButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.user.isTermsAccepted = sender.isSelected
        let imageName = sender.isSelected ? "Tick_Blue" : "square"
        sender.setImage(UIImage(named: imageName), for: .normal)
        updateRegisterButtonState()
    }
    
    @IBAction func onPressRegister(_ sender: UIButton) {
        viewModel.checkUserExists { [weak self] exists in
                guard let self = self else { return }
                
                if exists {
                    AlertManager.showAlert(on: self,
                                           title: "alert_error_title".localized,
                                           message: "alert_exists_msg".localized)
                } else {
                    self.viewModel.saveUserToCoreData()
                    self.performSegue(withIdentifier: "navigateToProfile", sender: self)
                }
            }
    }

    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let extraPadding: CGFloat = 40
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + extraPadding, right: 0)
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
        if let activeField = findFirstResponder(in: self.view) {
            let rect = activeField.convert(activeField.bounds, to: scrollview)
            scrollview.scrollRectToVisible(rect.insetBy(dx: 0, dy: -extraPadding), animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
    }

    private func updateRegisterButtonState() {
        let isValid = viewModel.isFormValid
        registerButttonView.isEnabled = isValid
        
        // Set the title using your localization helper
        let buttonTitle = "btn_register".localized
        
        UIView.animate(withDuration: 0.2) {
            self.registerButttonView.alpha = isValid ? 1.0 : 0.5
            
            if var config = self.registerButttonView.configuration {
                config.title = buttonTitle
                config.baseForegroundColor = .white
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.foregroundColor = .white
                    return outgoing
                }
                self.registerButttonView.configuration = config
            } else {
                // Legacy support for older iOS versions
                self.registerButttonView.setTitle(buttonTitle, for: .normal)
                self.registerButttonView.setTitleColor(.white, for: .normal)
                self.registerButttonView.setTitleColor(.white, for: .disabled)
            }
        }
    }

    private func setupAgreementLabel() {
        let fullText = "reg_terms_full".localized
        let linkText = "reg_terms_link".localized
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
            userdob.setErrorState(!isSilent && text.isEmpty, errorMessage: "reg_err_dob".localized)
        case linkedinUrl.textField:
            let result = Validator.isValidURL(text)
            linkedinUrl.setErrorState(!isSilent && !result, errorMessage: result ? nil : "Invalid LinkedIn URL")
            linkedinUrl.setAsLink(result)
        default: break
        }
    }

    // MARK: - Helpers
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
        let dateString = datePicker.date.toString()
        userdob.textField.text = dateString
        viewModel.user.dob = dateString
        view.endEditing(true)
        validate(textField: userdob.textField, isSilent: false)
        updateRegisterButtonState()
    }

    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder { return view }
        for subview in view.subviews {
            if let responder = findFirstResponder(in: subview) { return responder }
        }
        return nil
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
        guard let urlStr = linkedinUrl.textField.text,
                  let url = URL(string: urlStr),
                  url.scheme == "http" || url.scheme == "https" else {
                return
            }
            
            // SFSafariViewController provides a full Safari experience inside your app
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet // Looks modern and card-like
            present(safariVC, animated: true)
    }

    // MARK: - Image Source Logic
    private func showImageSourceOptions() {
        let alert = UIAlertController(title: "Profile Photo", message: "Select a source", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in self.presentCamera() })
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in self.presentPhotoPicker() })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = addPhotoBtn
            popover.sourceRect = addPhotoBtn.bounds
        }
        present(alert, animated: true)
    }

    private func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    }

    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToProfile" {
            if let destinationVC = segue.destination as? ProfileVC {
                let registrationData = viewModel.user
                let profileVM = ProfileViewModel(data: registrationData)
                destinationVC.viewModel = profileVM
            }
        }
    }
}

// MARK: - Extensions
extension RegistrationVC: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let rect = textField.convert(textField.bounds, to: scrollview)
        scrollview.scrollRectToVisible(rect.insetBy(dx: 0, dy: -20), animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.user.description = textView.text
        updatePlaceholderVisibility()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return textField == userPhonenumber.textField ? text.count <= 10 : true
    }
}

extension RegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    if let selectedImage = image as? UIImage {
                        self?.userImageView.image = selectedImage
                        let base64String = self?.convertImageToBase64String(selectedImage)
                        self?.viewModel.user.userImage = base64String
                        self?.updateRegisterButtonState()
                    }
                }
            }
        }
        
        // Handle Camera
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let selectedImage = (info[.editedImage] ?? info[.originalImage]) as? UIImage
            userImageView.image = selectedImage
            
            if let image = selectedImage {
                viewModel.user.userImage = convertImageToBase64String(image)
            }
            
            picker.dismiss(animated: true)
            updateRegisterButtonState()
        }
    
    private func convertImageToBase64String(_ image: UIImage) -> String? {
        
        return image.jpegData(compressionQuality: 0.7)?.base64EncodedString()
    }
}
