//
//  BorderedView.swift
//  ValidateUser
//
//  Created by MACM72 on 06/01/26.
//

import UIKit

protocol BorderStyling {
    var borderColorValue: UIColor? { get set }
    var borderWidthValue: CGFloat { get set }
    var cornerRadiusValue: CGFloat { get set }
}

extension BorderStyling where Self: UIView {
    func applyBorderStyle() {
        layer.borderColor = borderColorValue?.resolvedColor(with: traitCollection).cgColor
        layer.borderWidth = borderWidthValue
        layer.cornerRadius = cornerRadiusValue
        layer.masksToBounds = cornerRadiusValue > 0
    }

    func setupBorderTraitObservation() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
                self.applyBorderStyle()
            }
        }
    }
}

@IBDesignable
class BorderedView: UIView, BorderStyling {
    @IBInspectable var borderColorValue: UIColor? { didSet { applyBorderStyle() } }
    @IBInspectable var borderWidthValue: CGFloat = 0 { didSet { applyBorderStyle() } }
    @IBInspectable var cornerRadiusValue: CGFloat = 0 { didSet { applyBorderStyle() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorderTraitObservation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBorderTraitObservation()
    }
}

@IBDesignable
class BorderedImageView: UIImageView, BorderStyling {
    @IBInspectable var borderColorValue: UIColor? { didSet { applyBorderStyle() } }
    @IBInspectable var borderWidthValue: CGFloat = 0 { didSet { applyBorderStyle() } }
    @IBInspectable var cornerRadiusValue: CGFloat = 0 { didSet { applyBorderStyle() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorderTraitObservation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBorderTraitObservation()
    }
}
