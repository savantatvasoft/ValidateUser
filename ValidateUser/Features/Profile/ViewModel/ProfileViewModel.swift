//
//  ProfileViewModel.swift
//  ValidateUser
//
//  Created by MACM72 on 24/12/25.
//

import UIKit

class ProfileViewModel {
    
    let data: Registration
    
    init(data: Registration) {
        self.data = data
    }
    
    func getProfileImage() -> UIImage? {
            // 1. Check if the string exists
            if let base64String = data.userImage,
               // 2. Convert string to Data
               let imageData = Data(base64Encoded: base64String) {
                // 3. Return the image from the registration data
                return UIImage(data: imageData)
            }
            
            // 4. Default image if no photo was taken
            return UIImage(systemName: "person.circle.fill")
        }
}
