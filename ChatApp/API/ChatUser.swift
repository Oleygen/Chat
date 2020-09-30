//
//  ChatUser.swift
//  ChatApp
//
//  Created by Den on 2020-09-30.
//  Copyright © 2020 Den. All rights reserved.
//

import Foundation
import FirebaseAuth

struct ChatUser {
    var username: String
    let email: String
    init(_ user: User) {
        self.username = "Пользователь №" + String(user.uid.hashValue % 1000)
        self.email = user.email!
    }
}
