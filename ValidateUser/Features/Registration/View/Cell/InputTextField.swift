//
//  InputTextField.swift
//  ValidateUser
//
//  Created by MACM72 on 19/12/25.
//

import UIKit

class InputTextField: UIView {

    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var rightImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed("InputTextField", owner: self, options: nil)
        
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [
            .flexibleHeight,
            .flexibleWidth
        ]
        
    }
}
