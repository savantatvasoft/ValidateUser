//
//  String+Helper.swift
//  ValidateUser
//
//  Created by MACM72 on 22/12/25.
//

import Foundation
import UIKit

extension String {
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F,
                 0x1F900...0x1F9FF:
                return true
            default: continue
            }
        }
        return false
    }

    var localized: String {
            return NSLocalizedString(self, comment: "")
    }

    func toClickableText(linkText: String, color: UIColor = .systemBlue) -> NSAttributedString {
            let attributedString = NSMutableAttributedString(string: self)
            let nsString = self as NSString
            let range = nsString.range(of: linkText)

            if range.location != NSNotFound {
                attributedString.addAttributes([
                    .foregroundColor: color,
                    .font: UIFont.boldSystemFont(ofSize: 14)
                ], range: range)
            }

            return attributedString
        }
}
