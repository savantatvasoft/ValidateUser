import Foundation

class RegistrationViewModel {

    var user = Registration()
    
    var isFormValid: Bool {
            return !user.name.isEmpty &&
                   !user.email.isEmpty &&
                   !user.phone.isEmpty &&
                   !user.dob.isEmpty &&
                   !user.linkedinUrl.isEmpty &&
                   user.isTermsAccepted &&
                   user.userImage != nil
        }
}
