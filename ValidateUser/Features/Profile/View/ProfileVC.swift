//
//  ProfileVC.swift
//  ValidateUser
//
//  Created by MACM72 on 24/12/25.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameTitle: UILabel!
    @IBOutlet weak var userName: UserInput!
    @IBOutlet weak var userEmail: UserInput!
    @IBOutlet weak var userPhoneNumber: UserInput!
    @IBOutlet weak var userLinkedInUrl: UserInput!
    @IBOutlet weak var userDescription: UITextView!
    
    @IBOutlet weak var texViewContainer: UIView!
    var viewModel: ProfileViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let vm = viewModel else { return }
        
        // 1. Direct assignments from the model inside the VM
        userNameTitle.text = vm.data.name.isEmpty ? "Lorem ipsum" : "\(vm.data.name)"
        userImage.image = vm.getProfileImage()
        
        // 2. Setting your custom views
        userName.label.text = vm.data.name.isEmpty ? "Lorem ipsum" : "\(vm.data.name)"
        userEmail.label.text = vm.data.email
        userPhoneNumber.label.text = vm.data.phone
        userLinkedInUrl.label.text = vm.data.linkedinUrl
        userDescription.text = vm.data.description.isEmpty ? "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda." : "\(vm.data.description)"
        
        userEmail.image.image = UIImage(named: "Email")
        userPhoneNumber.image.image = UIImage(named: "Phone_Call")
        userLinkedInUrl.image.image = UIImage(named: "linked_In")
//        userLinkedInUrl.image.image = UIImage(named: "About_Us")
        
        // 3. Styling
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
    }
}
