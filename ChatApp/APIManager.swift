//
//  APIManager.swift
//  ChatApp
//
//  Created by Den on 2020-09-29.
//  Copyright © 2020 Den. All rights reserved.
//

import Foundation
import FirebaseAuth

class APIManager {
    
    static let shared = APIManager()
    private init() { }
    
    func createAccount(email: String,
                       password: String,
                       completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email,
                               password: password)
                               { (user: AuthDataResult?, error: Error?) in
            print("user \(String(describing: user))")
            print("error \(String(describing: error))")
            completion(user, error)
        }
    }
    
    
    func signOut() {
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
    }
}
