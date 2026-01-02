import UIKit

class InputField: UIView {

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var errorContainer: UIView!
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var leftImage: UIImageView!

    // MARK: - Init
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

        if let stackView = leftImage.superview as? UIStackView {
                stackView.isLayoutMarginsRelativeArrangement = true
                stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)

        }

        errorContainer.isHidden = true
        rightImage.isHidden = true
        leftImage.isHidden = true
        leftImage.image = nil
    }

    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }

    func setLeftImage(_ image: UIImage?) {
        if let img = image {
            leftImage.image = img
            leftImage.isHidden = false
        } else {
            leftImage.isHidden = true
            leftImage.image = nil
        }
        self.layoutIfNeeded()
    }

    func setErrorState(_ hasError: Bool, errorMessage: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3) {
                self.errorText.text = errorMessage
                self.errorContainer.isHidden = !hasError

                let isTextEmpty = self.textField.text?.isEmpty ?? true
                if isTextEmpty {
                    self.rightImage.isHidden = true
                } else {
                    self.rightImage.isHidden = false
                    let imageName = hasError ? Assets.warningIcon : Assets.successIcon
                    self.rightImage.image = UIImage(named: imageName)
                }

                self.layoutIfNeeded()
            }
        }
    }

    func setAsLink(_ isLink: Bool) {
        if isLink {
            textField.textColor = .systemBlue
        } else {
            textField.textColor = .label // or your default dull color
        }
    }

}
