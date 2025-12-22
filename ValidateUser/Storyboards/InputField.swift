import UIKit

@IBDesignable
class InputField: UIView {
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var errorContainer: UIView!
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var errorText: UILabel!
    
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
        setupUI()
    }
    
    private func setupUI() {
        errorContainer.isHidden = true
        rightImage.isHidden = true
    }
    
    // MARK: - Configuration Functions
    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }
    
    func setEditable(_ isEditable: Bool) {
        textField.isEnabled = isEditable
        textFieldContainerView.alpha = isEditable ? 1.0 : 0.6
    }
    
    // MARK: - Validation & UI Update
    func setErrorState(_ hasError: Bool, errorMessage: String? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                // 1. Set Error Text
                self.errorText.text = errorMessage
                
                // 2. Toggle Error Container
                self.errorContainer.isHidden = !hasError
                
                // 3. Image Logic
                let isTextEmpty = self.textField.text?.isEmpty ?? true
                if isTextEmpty {
                    self.rightImage.isHidden = true
                } else {
                    self.rightImage.isHidden = false
                    // Using your requested naming: Warning_Red vs Tick_Green
                    let imageName = hasError ? "Warning_Red" : "Tick_Green"
                    self.rightImage.image = UIImage(named: imageName)
                }
                
                // 4. Layout Refresh
                self.invalidateIntrinsicContentSize()
                self.layoutIfNeeded()
                self.superview?.layoutIfNeeded()
            }
        }
    }
}
