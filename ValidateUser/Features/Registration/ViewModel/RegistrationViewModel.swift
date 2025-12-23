import Foundation

class RegistrationViewModel {
    
    // The source of truth for the data
    var user = Registration()
    
    // Validation logic (No UIKit here!)
    var isFormValid: Bool {
        return Validator.isValidName(user.name).isValid &&
               Validator.isValidEmail(user.email).isValid &&
               Validator.isValidMobile(user.phone).isValid &&
               Validator.isValidURL(user.linkedinUrl) &&
               !user.dob.isEmpty &&
               user.isTermsAccepted
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
