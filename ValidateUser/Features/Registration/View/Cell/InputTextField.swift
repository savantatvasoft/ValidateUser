//
//  InputTextField.swift
//  ValidateUser
//
//  Created by MACM72 on 19/12/25.
//
import UIKit

@IBDesignable
class InputTextField: UIView {

   
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var rightImage: UIImageView!

    // Change your variables to include these defaults
    @IBInspectable var borderWidthIB: CGFloat = 0.5 { didSet { updateBorder() } }
    @IBInspectable var borderColorIB: UIColor? = .lightGray { didSet { updateBorder() } }
    @IBInspectable var cornerRadiusIB: CGFloat = 10 { didSet { updateBorder() } }

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
        
        // This loads the nib and connects the @IBOutlets to File's Owner
        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
        
        // Set your containerView reference if it isn't already linked
        self.containerView = xibView
        updateBorder()
        setupTextFieldPadding()
    }

    private func updateBorder() {
        containerView.layer.borderWidth = borderWidthIB
        containerView.layer.borderColor = borderColorIB?.cgColor
        containerView.layer.cornerRadius = cornerRadiusIB
        containerView.clipsToBounds = true
    }
    
    private func setupTextFieldPadding() {
        // Create a transparent spacer view
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    func setEditable(_ isEditable: Bool) {
        textField.isEnabled = isEditable
        // Adjust opacity so the user can see it is disabled
        containerView.alpha = isEditable ? 1.0 : 0.6
    }
    
    func setErrorState(_ hasError: Bool) {
            // Uses your existing IBInspectable properties
            self.borderColorIB = hasError ? .red : .lightGray
            self.borderWidthIB = hasError ? 2.0 : 1.0
        }
}



// App crash  because we use InputTextField as Cusotm Class

//import UIKit
//
//@IBDesignable
//class InputTextField: UIView {
//
//    @IBOutlet var containerView: UIView!
//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var rightImage: UIImageView!
//
//    @IBInspectable var borderWidthIB: CGFloat = 0 {
//        didSet { updateBorder() }
//    }
//
//    @IBInspectable var borderColorIB: UIColor? {
//        didSet { updateBorder() }
//    }
//
//    @IBInspectable var cornerRadiusIB: CGFloat = 0 {
//        didSet { updateBorder() }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        commonInit()
//    }
//
//    private func commonInit() {
//        guard containerView == nil else { return }
//
//        let bundle = Bundle(for: type(of: self))
//        bundle.loadNibNamed("InputTextField", owner: self, options: nil)
//
//        addSubview(containerView)
//        containerView.frame = bounds
//        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        updateBorder()
//    }
//
//    private func updateBorder() {
//        layer.borderWidth = borderWidthIB
//        layer.borderColor = borderColorIB?.cgColor
//        layer.cornerRadius = cornerRadiusIB
//        layer.masksToBounds = true
//    }
//}
