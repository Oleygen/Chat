//
//  ChatModel.swift
//  ChatApp
//
//  Created by Den on 2020-09-30.
//  Copyright © 2020 Den. All rights reserved.
//

import Foundation
import UIKit

class ChatModel {
    
    let apiManager = APIManager.shared
    
    weak var view: ChatViewController!
    
    init(view: ChatViewController) {
        self.view = view
        apiManager.getUser { user in
            self.view.setupUser(user)
            self.downloadAvatar(email: user.email)
            self.apiManager.listenerAllMessages = { [weak self] messages in
                self?.view.didReceive(allMessages: messages)
            }
            self.apiManager.listenerNewMessages = { [weak self] messages in
                self?.view.didReceive(newMessages: messages)
            }
            self.apiManager.updateAllMessages()
        }
    }
    
    func send(message: String) {
        apiManager.send(message: message)
    }
    
    func signOut() {
        apiManager.signOut()
    }
    
    func getUser() -> ChatUser {
        return apiManager.getUser()
    }
    
    func downloadAvatar(email: String) {
        apiManager.downloadUserAvatar(email: email) { data in
            let image = UIImage(data: data)!
            self.view!.setupUserAvatar(image)
        }
    }
}
