//
//  Helper.swift
//  ValidateUser
//
//  Created by MACM72 on 22/12/25.
//


import UIKit

import Foundation

struct ValidationResult {
    let isValid: Bool
    let error: String?
}

class Validator {
    
    static func isValidName(_ text: String?) -> ValidationResult {
        let name = text?.trimmingCharacters(in: .whitespaces) ?? ""
        if name.isEmpty { return ValidationResult(isValid: false, error: "Name is required") }
        if name.count < 3 { return ValidationResult(isValid: false, error: "Minimum 3 characters required") }
        // Regex to check for emojis or special characters if needed
        return ValidationResult(isValid: true, error: nil)
    }

    static func isValidEmail(_ text: String?) -> ValidationResult {
        let email = text?.trimmingCharacters(in: .whitespaces) ?? ""
        if email.isEmpty { return ValidationResult(isValid: false, error: "Email is required") }
        
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return predicate.evaluate(with: email)
            ? ValidationResult(isValid: true, error: nil)
            : ValidationResult(isValid: false, error: "Please enter a valid email address")
    }
    
    
    static func isValidMobile(_ text: String?) -> ValidationResult {
        let mobile = text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        // 1. Check if empty
        if mobile.isEmpty {
            return ValidationResult(isValid: false, error: "Mobile number is required")
        }
        
        // 2. Check if it contains only numbers
        let characterSet = CharacterSet.decimalDigits.inverted
        if mobile.rangeOfCharacter(from: characterSet) != nil {
            return ValidationResult(isValid: false, error: "Only digits are allowed")
        }
        
        // 3. Check for exact length of 10
        if mobile.count != 10 {
            return ValidationResult(isValid: false, error: "Mobile number must be exactly 10 digits")
        }
        
        return ValidationResult(isValid: true, error: nil)
    }
    
    
    static func isValidURL(_ urlString: String) -> Bool {
            // Basic LinkedIn URL check
            let pattern = "((http|https)://)?(www\\.)?linkedin\\.com/.*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
            return predicate.evaluate(with: urlString)
        }
    
}
