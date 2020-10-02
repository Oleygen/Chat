//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Den on 2020-09-30.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var settingsModel = SettingsModel(view: self)

    private var user: ChatUser?
    weak var chatViewController: ChatViewController?
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var setAvatarPhotoButton: UIButton!
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = settingsModel
        avatarImageView.setBorder()
    }
    
    func setupUser(_ user: ChatUser) {
        _ = view
        usernameTextField.text = user.username
        emailLabel.text = user.email
        avatarImageView.image = user.image
        self.user = user
    }
    
    @IBAction func setAvatarButtonAction(_ sender: Any) {
        showImagePicker()
    }
    
}


// MARK: - Image picker

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 1),
              let userEmail = user?.email
            else { return }
        dismiss(animated: true)
        avatarImageView.image = image
        user?.image = image
        chatViewController?.setupUserAvatar(image)
        settingsModel.saveImageToServer(imageData, for: userEmail)
    }
    
}
