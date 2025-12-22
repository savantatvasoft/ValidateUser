import UIKit

@IBDesignable
class InputTextField: UIView {

    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var rightImage: UIImageView! // Main status icon
    @IBOutlet weak var topmostViw: UIStackView! // Main bordered container
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var errorContainer: UIStackView! // Red error box

    // MARK: - Inspectables
    @IBInspectable var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }

    @IBInspectable var borderWidthIB: CGFloat = 0.5 { didSet { updateBorder() } }
    @IBInspectable var borderColorIB: UIColor? = .lightGray { didSet { updateBorder() } }
    @IBInspectable var cornerRadiusIB: CGFloat = 10 { didSet { updateBorder() } }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InputTextField", bundle: bundle)
        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
        self.containerView = xibView

        // 1. Constraints Configuration
        rightImage.translatesAutoresizingMaskIntoConstraints = false
        topmostViw.translatesAutoresizingMaskIntoConstraints = false
        errorContainer.translatesAutoresizingMaskIntoConstraints = false
        

        // 3. Configure Main Container Padding
        topmostViw.isLayoutMarginsRelativeArrangement = true
        topmostViw.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 16)

        // Initial States
        errorText.text = ""
        rightImage.isHidden = true
        errorText.isHidden = true
        errorContainer.isHidden = true
        rightImage.contentMode = .scaleAspectFit

        updateBorder()
        setupTextFieldPadding()
    }

    // MARK: - Public Methods
    func setErrorState(_ hasError: Bool, errorMessage: String? = nil) {
        // Toggle Visibility
        errorContainer.isHidden = !hasError
        
        if hasError {
            // Faded background but solid border
            errorContainer.backgroundColor = UIColor.red.withAlphaComponent(0.15)
            errorText.text = errorMessage
            errorText.textColor = .red
            errorText.isHidden = false
        }

        // Right image logic for the main field
        let isTextEmpty = textField.text?.isEmpty ?? true
        if isTextEmpty {
            rightImage.isHidden = true
        } else {
            rightImage.isHidden = false
            let imageName = hasError ? "Warning_Red" : "Tick_Green"
            rightImage.image = UIImage(named: imageName)
        }

        // Tint icons inside the error container to red
        errorContainer.subviews.forEach { $0.tintColor = .red }

        // Animate the height transition
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
        }
    }

    func setPlaceholder(_ text: String) {
        self.placeholder = text
    }

    func setEditable(_ isEditable: Bool) {
        textField.isEnabled = isEditable
        containerView.alpha = isEditable ? 1.0 : 0.6
    }

    // MARK: - Private Setup
    private func updateBorder() {
        guard let borderTarget = topmostViw else { return }
        borderTarget.layer.borderWidth = borderWidthIB
        borderTarget.layer.borderColor = borderColorIB?.cgColor
        borderTarget.layer.cornerRadius = cornerRadiusIB
        borderTarget.clipsToBounds = true

        containerView.layer.borderWidth = 0
        containerView.layer.cornerRadius = 0
    }

    private func setupTextFieldPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
}
