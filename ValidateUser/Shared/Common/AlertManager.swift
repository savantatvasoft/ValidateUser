//
//  AlertManager.swift
//  ValidateUser
//
//  Created by MACM72 on 24/12/25.
//

import UIKit

struct AlertManager {
    static func showAlert(on vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(
            title: title.localized,
            message: message.localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "alert_ok".localized, style: .default))
        vc.present(alert, animated: true)
    }
}
