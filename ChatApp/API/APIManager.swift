//
//  APIManager.swift
//  ChatApp
//
//  Created by Den on 2020-09-29.
//  Copyright © 2020 Den. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class APIManager {
    
    static let shared = APIManager()
    private init() {
        setupListener()
    }
    
    private let database = Database.database().reference()
    private let chatMessagesPath = "/chat/messages"
    
    private func setupListener() {
        let ref = database.child(chatMessagesPath)
        ref.observe( .value, with: { (snapshot) in
             if let userDict = snapshot.value as? [String: Any] {
                  print(userDict)
             }
        })
    }
    
    // MARK: - Authorization
    
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
        do {
            try Firebase.Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    // MARK: - Chat
    
    func send(message: String) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let timestamp = Date().timeIntervalSince1970
        let messageData: [String: Any] = ["timestamp": timestamp,
                                          "userEmail": userEmail,
                                          "message": message,]
        let messageId = UUID().uuidString
        database.child(chatMessagesPath + "/" + messageId).setValue(messageData)
    }
    
}
