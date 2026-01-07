import UIKit

class InputField: UIView {

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var errorContainer: UIView!
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageLeadingConstraint: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InputField", bundle: bundle)
        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        errorTopConstraint.constant = 0
        errorHeightConstraint.constant = 0
        errorContainer.isHidden = true
        errorContainer.clipsToBounds = true
        errorContainer.alpha = 0
        rightImage.isHidden = true
        setLeftImage(nil)
    }

    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }

    func setLeftImage(_ image: UIImage?) {
        if let img = image {
            leftImageWidthConstraint.constant = 24
            leftImageLeadingConstraint.constant = 10
            leftImage.image = img
            leftImage.isHidden = false
        } else {
            leftImageWidthConstraint.constant = 0
            leftImageLeadingConstraint.constant = 4
            leftImage.isHidden = true
            leftImage.image = nil
        }
        self.layoutIfNeeded()
    }

    func setErrorState(_ hasError: Bool, errorMessage: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.errorText.text = errorMessage
            if hasError {
                self.errorContainer.isHidden = false
            }

            UIView.animate(withDuration: 0.3, animations: {
                self.errorTopConstraint.constant = hasError ? 5 : 0
                self.errorHeightConstraint.constant = hasError ? 30 : 0
                self.errorContainer.alpha = hasError ? 1 : 0

                let isTextEmpty = self.textField.text?.isEmpty ?? true
                if isTextEmpty {
                    self.rightImage.isHidden = true
                } else {
                    self.rightImage.isHidden = false
                    let imageName = hasError ? Assets.warningIcon : Assets.successIcon
                    self.rightImage.image = UIImage(named: imageName)
                }

                self.layoutIfNeeded()
            }, completion: { _ in
                if !hasError {
                    self.errorContainer.isHidden = true
                }
            })
        }
    }

    func setAsLink(_ isLink: Bool) {
        if isLink {
            textField.textColor = .systemBlue
        } else {
            textField.textColor = .label
        }
    }
}
