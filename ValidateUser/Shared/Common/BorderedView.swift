//
//  BorderedView.swift
//  ValidateUser
//
//  Created by MACM72 on 06/01/26.
//

import UIKit

@IBDesignable
class BorderedView: UIView {
    
    @IBInspectable var borderColorValue: UIColor? {
        didSet { updateBorderColor() }
    }
    
    @IBInspectable var borderWidthValue: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidthValue }
    }
    
    @IBInspectable var cornerRadiusValue: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadiusValue
            layer.masksToBounds = cornerRadiusValue > 0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTraitObservation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTraitObservation()
    }
    
    // MARK: - iOS 17+ Trait Change API
    private func setupTraitObservation() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
                self.updateBorderColor()
            }
        }
    }
    
    // MARK: - iOS 16 and earlier (Fallback)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 17.0, *) {
            // Handled by registerForTraitChanges
        } else {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateBorderColor()
            }
        }
    }
    
    private func updateBorderColor() {
        layer.borderColor = borderColorValue?.resolvedColor(with: traitCollection).cgColor
    }
}
