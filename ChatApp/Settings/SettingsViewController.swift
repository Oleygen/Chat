//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Den on 2020-09-30.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var user: ChatUser?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var setAvatarPhotoButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUser(_ user: ChatUser) {
        _ = view
        usernameLabel.text = user.username
        passwordLabel.text = "******"
        emailLabel.text = user.email
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        avatarImageView.image = image
    }
    
}
