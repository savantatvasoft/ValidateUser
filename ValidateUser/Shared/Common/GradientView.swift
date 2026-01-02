//
//  GradientView.swift
//  ValidateUser
//
//  Created by MACM72 on 19/12/25.
//

import UIKit

@IBDesignable
final class GradientView: UIView {

    // MARK: - Gradient Colors
    @IBInspectable var topColor: UIColor = UIColor(red: 254/255, green: 254/255, blue: 255/255, alpha: 1)
    @IBInspectable var bottomColor: UIColor = UIColor(red: 215/255, green: 215/255, blue: 255/255, alpha: 1)

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient()
    }

    // MARK: - Apply Gradient
    private func applyGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)

        // Remove existing gradient layers to avoid duplicates
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        layer.insertSublayer(gradient, at: 0)
    }
}
