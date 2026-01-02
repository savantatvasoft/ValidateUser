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

            if let base64String = data.userImage,
               let imageData = Data(base64Encoded: base64String) {
                return UIImage(data: imageData)
            }
            return UIImage(systemName: "person.circle.fill")
        }
}
