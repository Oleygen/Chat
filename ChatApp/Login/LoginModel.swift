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
                                 password: password) { [weak self] (response, error) in
            guard let self = self else { return }
            guard let response = response, let email = response.user.email else {
                self.authenticationError()
                return
            }
            self.view.successSignIn(email: email)
        }
    }
    
    func signIn(email: String,
                password: String) {
        apiManager.signIn(email: email,
                          password: password) { [weak self] (response, error) in
            guard let self = self else { return }
            guard let response = response, let email = response.user.email else {
                self.authenticationError()
                return
            }
            self.view.successSignIn(email: email)
        }
    }
    
    
    private func authenticationError() {
        view.showError()
    }
    
}
