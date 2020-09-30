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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUser(_ user: ChatUser) {
        self.user = user
    }

}
