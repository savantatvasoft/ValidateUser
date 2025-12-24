import Foundation
import CoreData

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
    
    func checkUserExists(completion: @escaping (Bool) -> Void) {
            let context = CoreDataManager.shared.context
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            
            // Predicate to check name OR email
            fetchRequest.predicate = NSPredicate(format: "name == %@ OR email == %@", user.name, user.email)
            
            do {
                let count = try context.count(for: fetchRequest)
                completion(count > 0)
            } catch {
                print("Fetch error: \(error)")
                completion(false)
            }
        }
        
        // Save user to Core Data
        func saveUserToCoreData() {
            let context = CoreDataManager.shared.context
            let newUser = UserEntity(context: context)
            
            newUser.name = user.name
            newUser.email = user.email
            newUser.phone = user.phone
            newUser.dob = user.dob
            newUser.linkedinUrl = user.linkedinUrl
            newUser.userDescription = user.description
            newUser.userImage = user.userImage // Base64 string
            
            CoreDataManager.shared.saveContext()
        }
}
