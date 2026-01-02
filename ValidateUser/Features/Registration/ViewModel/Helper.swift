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
        if name.isEmpty { return ValidationResult(isValid: false, error: "reg_name_req".localized) }
        if name.count < 3 { return ValidationResult(isValid: false, error: "reg_name_count".localized) }
        return ValidationResult(isValid: true, error: nil)
    }

    static func isValidEmail(_ text: String?) -> ValidationResult {
        let email = text?.trimmingCharacters(in: .whitespaces) ?? ""
        if email.isEmpty { return ValidationResult(isValid: false, error: "reg_email_req".localized) }
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)

        return predicate.evaluate(with: email)
            ? ValidationResult(isValid: true, error: nil)
        : ValidationResult(isValid: false, error: "reg_email_valid".localized)
    }

    static func isValidMobile(_ text: String?) -> ValidationResult {
        let mobile = text?.trimmingCharacters(in: .whitespaces) ?? ""
        if mobile.isEmpty {
            return ValidationResult(isValid: false, error: "reg_mob_req".localized)
        }
        let characterSet = CharacterSet.decimalDigits.inverted
        if mobile.rangeOfCharacter(from: characterSet) != nil {
            return ValidationResult(isValid: false, error: "reg_mob_digit".localized)
        }
        if mobile.count != 10 {
            return ValidationResult(isValid: false, error: "reg_mob_count".localized)
        }

        return ValidationResult(isValid: true, error: nil)
    }

    static func isValidURL(_ urlString: String) -> Bool {
            let pattern = "((http|https)://)?(www\\.)?linkedin\\.com/.*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
            return predicate.evaluate(with: urlString)
        }

}
