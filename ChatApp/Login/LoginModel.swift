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
    
    func createAccount(email: String, password: String) {
        apiManager.createAccount(email: "testAccount1@gmail.com", password: "12345678")
    }
    
}
