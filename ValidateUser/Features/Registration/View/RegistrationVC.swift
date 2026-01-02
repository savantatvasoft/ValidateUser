import UIKit
import PhotosUI

class RegistrationVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var username: InputField!
    @IBOutlet weak var userEmail: InputField!
    @IBOutlet weak var userdob: InputField!
    @IBOutlet weak var userPhonenumber: InputField!

    @IBOutlet weak var userLinkedin: InputField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var userDescriptionTextView: UITextView!
    @IBOutlet weak var descriptionPlaceholderLabel: UILabel!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var checkButtonView: UIButton!
    @IBOutlet weak var registerButttonView: UIButton!

    // MARK: - Properties
    private let viewModel = RegistrationViewModel()
    private let datePicker = UIDatePicker()
    private lazy var keyboardManager = KeyboardManager(scrollView: scrollview, viewController: self)
    private lazy var imageManager: ImagePickerManager = {
        let manager = ImagePickerManager(viewController: self)
        manager.onImageSelected = { [weak self] image in
            self?.handleImageSelection(image)
        }
        return manager
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        keyboardManager.observeKeyboard()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bringSubviewToFront(addPhotoBtn)
    }

    deinit {
        keyboardManager.stopObserving()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        setupDatePicker()
        setupAgreementLabel()
        configureInputFields()
        updateRegisterButtonState()
    }

    private func configureInputFields() {
        username.setPlaceholder("reg_ph_name".localized)
        userEmail.setPlaceholder("reg_ph_email".localized)
        userdob.setPlaceholder("reg_ph_dob".localized)
        userPhonenumber.setPlaceholder("reg_ph_phone".localized)
        userLinkedin.setPlaceholder("reg_ph_linkedin".localized)
        userPhonenumber.textField.keyboardType = .numberPad
        userLinkedin.textField.keyboardType = .URL
        userLinkedin.textField.autocapitalizationType = .none
        userLinkedin.setLeftImage(UIImage(named: Assets.linkedInIcon))
        userLinkedin.textField.delegate = self
        userDescriptionTextView.delegate = self
        userDescriptionTextView.isScrollEnabled = false
        userLinkedin.textField.clearButtonMode = .whileEditing
        updatePlaceholderVisibility()

        let fields = [username, userEmail, userdob, userPhonenumber, userLinkedin].compactMap { $0 }
        fields.forEach { field in
            field.textField.delegate = self
            field.textField.addTarget(self, action: #selector(onTyping(_:)), for: .editingChanged)
        }
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
        doubleTap.numberOfTapsRequired = 2
        userLinkedin.addGestureRecognizer(doubleTap)
    }

    // MARK: - Actions
    @objc private func onTyping(_ textField: UITextField) {
        let text = textField.text ?? ""

        switch textField {
            case username.textField: viewModel.user.name = text
            case userEmail.textField: viewModel.user.email = text
            case userPhonenumber.textField: viewModel.user.phone = text
            case userLinkedin.textField: viewModel.user.linkedinUrl = text
            default: break
        }
        validate(textField: textField, isSilent: false)
        updateRegisterButtonState()
    }

    @IBAction func onAddImage(_ sender: UIButton) {
        imageManager.showOptions(sourceView: sender)
    }

    @IBAction func onPressCheckButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.user.isTermsAccepted = sender.isSelected
        let imageName = sender.isSelected ? Assets.checkOn : Assets.checkOff
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

    private func handleImageSelection(_ image: UIImage) {
        userImageView.image = image
        viewModel.updateUserImage(image)
        updateRegisterButtonState()
    }
   
    private func updateRegisterButtonState() {
        let isValid = viewModel.isFormValid
        registerButttonView.isEnabled = isValid
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
                self.registerButttonView.setTitle(buttonTitle, for: .normal)
                self.registerButttonView.setTitleColor(.white, for: .normal)
                self.registerButttonView.setTitleColor(.white, for: .disabled)
            }
        }
    }

    private func setupAgreementLabel() {
        let fullText = "reg_terms_full".localized
        let linkText = "reg_terms_link".localized
        
        guard !fullText.isEmpty, !linkText.isEmpty else { return }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let nsFullText = fullText as NSString
        let range = nsFullText.range(of: linkText)
        
        if range.location != NSNotFound {
            let linkColor = UIColor.systemBlue
            attributedString.addAttributes([
                .foregroundColor: linkColor,
                .font: UIFont.boldSystemFont(ofSize: 14)
            ], range: range)
        }
        agreementLabel.attributedText = attributedString
        agreementLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTermsTap(_:)))
        agreementLabel.addGestureRecognizer(tapGesture)
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
            
            case userLinkedin.textField:
                let result = Validator.isValidURL(text)
                userLinkedin.setErrorState(!isSilent && !result, errorMessage: result ? nil : "reg_invalid_url".localized)
                userLinkedin.setAsLink(result)
                userLinkedin.textField.isUserInteractionEnabled = true

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

        let done = UIBarButtonItem(
            title: "reg_done".localized,
            style: .prominent,
            target: self,
            action: #selector(donePressed)
        )

        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        toolbar.setItems([flexibleSpace, done], animated: false)
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

    private func updatePlaceholderVisibility() {
        descriptionPlaceholderLabel.isHidden = !userDescriptionTextView.text.isEmpty || userDescriptionTextView.isFirstResponder
    }

    @objc private func handleTermsTap(_ gesture: UITapGestureRecognizer) {
        guard let fullText = agreementLabel.text else { return }
        let linkText = "reg_terms_link".localized
        let range = (fullText as NSString).range(of: linkText)
        if gesture.didTapAttributedTextInLabel(label: agreementLabel, inRange: range) {
            if let url = URL(string: "reg_google".localized) { UIApplication.shared.open(url) }
        }
    }
    
    @objc private func handleLinkTap() {
        let urlStr = userLinkedin.textField.text
        WebViewManager.open(urlStr: urlStr, from: self)
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == userLinkedin.textField {
            let text = textField.text ?? ""
            if Validator.isValidURL(text) && textField.isFirstResponder {
                handleLinkTap()
                return false
            }
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let rect = textField.convert(textField.bounds, to: scrollview)
        scrollview.scrollRectToVisible(rect.insetBy(dx: 0, dy: -20), animated: true)
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.user.description = textView.text
        updatePlaceholderVisibility()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if textField == userPhonenumber.textField {
            return newText.count <= 10
        }
        return true
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
