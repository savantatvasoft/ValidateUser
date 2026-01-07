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
        userNameTitle.text = vm.data.name
        userImage.image = vm.getProfileImage()
        userName.label.text = vm.data.name
        userEmail.label.text = vm.data.email
        userPhoneNumber.label.text = vm.data.phone
        userLinkedInUrl.label.text = vm.data.linkedinUrl
        userDescription.textContainer.lineFragmentPadding = 0
        userDescription.text = vm.data.description
        userEmail.image.image = UIImage(named: Assets.emailIcon)
        userPhoneNumber.image.image = UIImage(named: Assets.phoneIcon)
        userLinkedInUrl.image.image = UIImage(named: Assets.linkedInIcon)
    }
}
