//
//  ChatModel.swift
//  ChatApp
//
//  Created by Den on 2020-09-30.
//  Copyright © 2020 Den. All rights reserved.
//

import Foundation

class ChatModel {
    
    let apiManager = APIManager.shared
    
    weak var view: ChatViewController!
    
    init() {
        apiManager.listener = { [weak self] messages in
            self?.view.didReceive(messages: messages)
        }
        apiManager.updateAllMessages()
    }
    
    func send(message: String) {
        apiManager.send(message: message)
    }
    
    func signOut() {
        apiManager.signOut()
    }
    
}
