import Foundation
import CoreData
import UIKit

struct ValidationResult {
    let isValid: Bool
    let error: String?
}

class RegistrationViewModel {

    private let repository = UserRepository()
    var user = Registration()

    var isFormValid: Bool {
        return  validateName(user.name).isValid &&
                validateEmail(user.email).isValid &&
                validateMobile(user.phone).isValid &&
                isValidURL(user.linkedinUrl) &&
                user.dob != nil &&
                user.isTermsAccepted &&
                user.userImage != nil
    }

    func validateName(_ text: String?) -> ValidationResult {
        let name = text?.trimmingCharacters(in: .whitespaces) ?? ""
        if name.isEmpty { return ValidationResult(isValid: false, error: "reg_name_req".localized) }
        if name.count < 3 { return ValidationResult(isValid: false, error: "reg_name_count".localized) }
        return ValidationResult(isValid: true, error: nil)
    }

    func validateEmail(_ text: String?) -> ValidationResult {
        let email = text?.trimmingCharacters(in: .whitespaces) ?? ""
        if email.isEmpty { return ValidationResult(isValid: false, error: "reg_email_req".localized) }
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)

        return predicate.evaluate(with: email)
            ? ValidationResult(isValid: true, error: nil)
            : ValidationResult(isValid: false, error: "reg_email_valid".localized)
    }

    func validateMobile(_ text: String?) -> ValidationResult {
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

    func isValidURL(_ urlString: String) -> Bool {
        let pattern = "((http|https)://)?(www\\.)?linkedin\\.com/.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: urlString)
    }

    func checkUserExists(completion: @escaping (Bool) -> Void) {
        completion(repository.userExists(
            name: user.name,
            email: user.email
        ))
    }

    func saveUser() {
        repository.save(user: user)
    }

    func updateUserImage(_ image: UIImage) {
        user.userImage = image.jpegData(compressionQuality: 0.8)
    }
}
