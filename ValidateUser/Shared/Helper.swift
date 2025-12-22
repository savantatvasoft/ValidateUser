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
}
