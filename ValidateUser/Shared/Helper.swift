//
//  Helper.swift
//  ValidateUser
//
//  Created by MACM72 on 22/12/25.
//


import UIKit

struct Validator {
    
    // Global rule for Name validation
    static func isValidName(_ text: String?) -> (isValid: Bool, error: String?) {
        guard let text = text, !text.isEmpty else {
            return (false, "Field cannot be empty")
        }
        
        if text.count < 3 {
            return (false, "Minimum 3 characters required")
        }
        
        if text.count > 10 {
            return (false, "Maximum 10 characters allowed")
        }
        
        if text.containsEmoji {
            return (false, "Emojis are not allowed")
        }
        
        return (true, nil)
    }
}
