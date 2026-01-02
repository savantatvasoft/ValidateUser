//
//  UserInput.swift
//  ValidateUser
//
//  Created by MACM72 on 24/12/25.
//

import Foundation
import UIKit

class UserInput: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserInput", bundle: bundle)
        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
    }

}
