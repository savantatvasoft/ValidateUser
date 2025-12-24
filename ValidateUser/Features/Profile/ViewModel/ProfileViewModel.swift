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
        if let name = data.userImage { return UIImage(named: name) }
        return UIImage(systemName: "person.circle.fill")
    }
}
