//
//  ImagePickerManager.swift
//  ValidateUser
//
//  Created by MACM72 on 02/01/26.
//
import UIKit
import PhotosUI

class ImagePickerManager: NSObject {
    
    private weak var viewController: UIViewController?
    var onImageSelected: ((UIImage) -> Void)?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showOptions(sourceView: UIView) {
        let alert = UIAlertController(title: "reg_profile".localized, message: "reg_source".localized, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "reg_camera".localized, style: .default) { _ in
            self.presentCamera()
        })
        
        alert.addAction(UIAlertAction(title: "reg_ph_library".localized, style: .default) { _ in
            self.presentPhotoPicker()
        })
        
        alert.addAction(UIAlertAction(title: "reg_cancel".localized, style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
        }
        
        viewController?.present(alert, animated: true)
    }
    
    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        viewController?.present(picker, animated: true)
    }
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        viewController?.present(picker, animated: true)
    }
}

// MARK: - Delegates
extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        if let selectedImage = image {
            onImageSelected?(selectedImage)
        }
        picker.dismiss(animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                if let selectedImage = image as? UIImage {
                    self?.onImageSelected?(selectedImage)
                }
            }
        }
    }
}
