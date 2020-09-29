//
//  LoginModel.swift
//  ChatApp
//
//  Created by Den on 2020-09-29.
//  Copyright © 2020 Den. All rights reserved.
//

import Foundation


class LoginModel {
    
    let apiManager = APIManager.shared
    
    weak var view: LoginViewController!
    
    func createAccount(email: String,
                       password: String) {
        apiManager.createAccount(email: email,
                                 password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            guard let _ = error else {
                self.authenticationError()
                return
            }
            guard let _ = user else {
                self.didCreateAccount()
                return
            }
        }
    }
    
    private func didCreateAccount() {
        view.didCreateAccount()
    }
    
    private func authenticationError() {
        view.showError()
    }
    
}
