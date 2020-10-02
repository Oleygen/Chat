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
        view.setupUser(apiManager.getUser())
        apiManager.listenerAllMessages = { [weak self] messages in
            self?.view.didReceive(allMessages: messages)
        }
        apiManager.listenerNewMessages = { [weak self] messages in
            self?.view.didReceive(newMessages: messages)
        }
        apiManager.updateAllMessages()
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
        apiManager.downloadUserAvatar(email: "asdasd@gmail.com") { data in
            let image = UIImage(data: data)!
            self.view!.setupUserAvatar(image)
        }
    }
}
