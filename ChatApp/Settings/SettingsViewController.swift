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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var setAvatarPhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #warning("only for debug")
        setAvatarPhotoButton.isEnabled = false
        
    }
    
    func setupUser(_ user: ChatUser) {
        _ = view
        usernameLabel.text = user.username
        passwordLabel.text = "******"
        emailLabel.text = user.email
        self.user = user
    }

}
