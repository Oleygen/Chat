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
import FirebaseStorage

class APIManager {
    
    static let shared = APIManager()
    private init() {
        messagesDatabase = database.child(chatMessagesPath)
        imagesStorage = storage.child(imagesPath)
        usernamesDatabase = database.child(usernamesPath)
        setupListener()
    }
    
    // Messages Database
    private let database = Database.database().reference()
    private let chatMessagesPath = "/chat/messages"
    private let messagesDatabase: DatabaseReference
    var listenerAllMessages: (([Message]) -> Void)?
    var listenerNewMessages: (([Message]) -> Void)?
    
    // Images Storage
    private let storage = Storage.storage().reference()
    private let imagesStorage: StorageReference
    private let imagesPath = "/images"
    
    // Usernames
    private let usernamesPath = "/usernames"
    private let usernamesDatabase: DatabaseReference
    
    private func setupListener() {
        
        messagesDatabase.observe(.childAdded, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            if let object = snapshot.value as? String,
               let objectData = object.data(using: .utf8),
               let decodedMessage = try? JSONDecoder().decode(Message.self,
                                                              from: objectData) {
                self.listenerNewMessages?([decodedMessage])
            }
        })
        messagesDatabase.observe(.value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            if let _ = snapshot.value as? [String: String] {
                self.listenerAllMessages?(self.decodeMessages(snapshot))
            }
        })
    }
    
    private func decodeMessages(_ snapshot: DataSnapshot) -> [Message] {
        guard let messagesDict = snapshot.value as? [String: String] else { return [] }
        var messages: [Message] = []
        for (_, message) in messagesDict {
            if let messageData = message.data(using: .utf8),
               let decodedMessage = try? JSONDecoder().decode(Message.self,
                                                              from: messageData) {
                messages.append(decodedMessage)
            }
            
        }
        messages.sort(by: { $0.timestamp < $1.timestamp })
        return messages
    }
    
    // MARK: - Authorization
    
    func createAccount(email: String,
                       password: String,
                       completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { (user: AuthDataResult?, error: Error?) in
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
            assert(false)
            print("Error signing out: %@", signOutError)
        }
    }
    
    func changePassword(_ newPassword: String,
                        completion: @escaping (_ success: Bool) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: email,
                                                      password: newPassword)
        user.reauthenticate(with: credential,
                            completion: { (_, error) in
            assert(error != nil, "error updatePassword \(String(describing: error))")
            Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
                assert(error != nil, "error updatePassword \(String(describing: error))")
                let isSuccess = error == nil
                completion(isSuccess)
            }
        })
        
    }
    
    func saveUsername(_ username: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        usernamesDatabase.child(userID).setValue(username)
    }
    
    func getLoggedEmail() -> String {
        return Firebase.Auth.auth().currentUser!.email!
    }
    
    func getUser(completion: @escaping (ChatUser) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        usernamesDatabase.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.value as? String {
                let user = ChatUser(Firebase.Auth.auth().currentUser!, name: name)
                completion(user)
            } else {
                completion(ChatUser(Firebase.Auth.auth().currentUser!))
            }
        }
    }
    
    func getUser() -> ChatUser {
        return ChatUser(Firebase.Auth.auth().currentUser!)
    }
    
    
    // MARK: - Chat
    
    func send(message: String, user: ChatUser) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let timestamp = String(Date().timeIntervalSince1970)
        let message = Message(senderName: user.name,
                              timestamp: timestamp,
                              userEmail: userEmail,
                              message: message)
        guard let messageJson = try? JSONEncoder().encode(message) else {
            assert(false)
            return
        }
        let messageJsonString = String(data: messageJson, encoding: .utf8)
        messagesDatabase.childByAutoId().setValue(messageJsonString)
    }
    
    func updateAllMessages() {
        messagesDatabase.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            self.listenerAllMessages?(self.decodeMessages(snapshot))
        })
    }
    
    
    // MARK: - Images
    
    func saveImageToServer(_ imageData: Data, for userEmail: String) {
        let imageReference = imagesStorage.child(userEmail)
        imageReference.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                assert(false, "error image save \(error)")
            }
        }
    }
    
    func downloadUserAvatar(email: String,
                            completion: @escaping (Data) -> Void) {
        let imageReference = imagesStorage.child(email)
        imageReference.downloadURL { (url, error) in
            guard let imageUrl = url else { return }
            let request = URLRequest(url: imageUrl)
            URLSession.shared.dataTask(with: request) { responseData, _, error in
                assert(error != nil)
                DispatchQueue.main.async {
                    if let data = responseData {
                        completion(data)
                    }
                }
            }.resume()
        }
    }
    
}
