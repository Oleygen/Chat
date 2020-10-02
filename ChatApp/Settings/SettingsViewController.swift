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
    @IBOutlet private weak var userIntialsLabel: UILabel!
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = settingsModel
        avatarImageView.setBorder()
        usernameTextField.delegate = self
    }
    
    func setupUser(_ user: ChatUser) {
        _ = view
        usernameTextField.text = user.name
        emailLabel.text = user.email
        if let avatar = user.avatar {
            avatarImageView.image = avatar
        }
        userIntialsLabel.text = String(user.name.prefix(2))
        self.user = user
    }
    
    @IBAction func setAvatarButtonAction(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter new password",
                                                message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            // textField.placeholder = "Enter new password"
        }
        let saveAction = UIAlertAction(title: "Confirm",
                                       style: UIAlertAction.Style.default,
                                       handler: { alert -> Void in
            let passwordTextField = alertController.textFields![0] as UITextField
            let _ = passwordTextField.text
        })
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.default,
                                         handler: { (action: UIAlertAction!) -> Void in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
        user?.avatar = image
        chatViewController?.setupUserAvatar(image)
        settingsModel.saveImageToServer(imageData, for: userEmail)
    }
    
}


// MARK: - Username

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let newName = textField.text else { return true }
        user?.name = newName
        userIntialsLabel.text = String(newName.prefix(2))
        return true
    }
    
}
