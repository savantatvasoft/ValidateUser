//
//  UIButton+Extension.swift
//  ValidateUser
//
//  Created by MACM72 on 02/01/26.
//

import UIKit

extension UIButton {
    
    func updateState(isEnabled: Bool, title: String) {
        self.isEnabled = isEnabled
   
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.alpha = isEnabled ? 1.0 : 0.5
            
            if var config = self.configuration {
                config.title = title
                config.baseForegroundColor = .white
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.foregroundColor = .white
                    return outgoing
                }
                self.configuration = config
            } else {
                self.setTitle(title, for: .normal)
                self.setTitleColor(.white, for: .normal)
                self.setTitleColor(.white, for: .disabled)
            }
        }
    }
}
