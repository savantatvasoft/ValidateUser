//
//  KeyboardManager.swift
//  ValidateUser
//
//  Created by MACM72 on 02/01/26.
//

import UIKit

class KeyboardManager {
    private weak var scrollView: UIScrollView?
    private weak var viewController: UIViewController?
    private let extraPadding: CGFloat = 40

    init(scrollView: UIScrollView, viewController: UIViewController) {
        self.scrollView = scrollView
        self.viewController = viewController
    }

    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupTapToDismiss()
    }

    func stopObserving() {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        viewController?.view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        viewController?.view.endEditing(true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let scrollView = scrollView,
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + extraPadding, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeField = viewController?.view.findFirstResponder() {
            let rect = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -extraPadding), animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
}
