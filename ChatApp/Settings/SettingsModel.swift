//
//  SettingsModel.swift
//  ChatApp
//
//  Created by Den on 2020-10-02.
//  Copyright © 2020 Den. All rights reserved.
//

import Foundation

class SettingsModel {
    
    weak var view: SettingsViewController!
    
    let apiManager = APIManager.shared
    
    init(view: SettingsViewController) {
        self.view = view
    }
    
    func saveImageToServer(_ imageData: Data, for userEmail: String) {
        apiManager.saveImageToServer(imageData, for: userEmail)
    }
    
    func saveUsername(_ username: String) {
        apiManager.saveUsername(username)
    }
    
    func setNewPassword(_ password: String) {
        apiManager.changePassword(password) { success in
            assert(success, "error of changing password")
        }
    }
}
