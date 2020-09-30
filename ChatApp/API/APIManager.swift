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
        reference = database.child(chatMessagesPath)
        setupListener()
    }
    
    private let database = Database.database().reference()
    private let chatMessagesPath = "/chat/messages"
    let reference: DatabaseReference
    var listener: (([Message]) -> Void)?
    
    private func setupListener() {
        reference.observe( .value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            
            #warning("remove later")
            guard let messagesDict = snapshot.value as? [String: String] else { return }
            print(messagesDict)
            
            self.listener?(self.decodeMessages(snapshot))
        })
    }
    
    private func decodeMessages(_ snapshot: DataSnapshot) -> [Message] {
        guard let messagesDict = snapshot.value as? [String: String] else { return [] }
        var messages: [Message] = []
        for (_, message) in messagesDict {
            let decodedMessage = try! JSONDecoder().decode(Message.self, from: message.data(using: .utf8)!)
            messages.append(decodedMessage)
        }
        messages.sort(by: { $0.timestamp < $1.timestamp })
        return messages
    }
    
    // MARK: - Authorization
    
    func createAccount(email: String,
                       password: String,
                       completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email,
                               password: password)
                               { (user: AuthDataResult?, error: Error?) in
            completion(user, error)
        }
    }
    
    func signIn(email: String,
                password: String,
                completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { (user: AuthDataResult?, error: Error?) in
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
        let timestamp = String(Date().timeIntervalSince1970)
        let message = Message(timestamp: timestamp,
                                userEmail: userEmail,
                                message: message)
        let messageJson = try! JSONEncoder().encode(message)
        let messageJsonString = String(data: messageJson, encoding: .utf8)
        database.child(chatMessagesPath).childByAutoId().setValue(messageJsonString)
    }
    
    func updateAllMessages() {
        reference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            self.listener?(self.decodeMessages(snapshot))
        })
    }
    
}
