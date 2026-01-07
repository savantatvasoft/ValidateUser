//
//  WebViewManager.swift
//  ValidateUser
//
//  Created by MACM72 on 02/01/26.
//

import UIKit
import SafariServices

struct WebViewManager {

    static func open(urlStr: String?, from vc: UIViewController) {
        guard let url = URLFormatter.format(urlStr) else { return }

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        vc.present(safariVC, animated: true)
    }
}
