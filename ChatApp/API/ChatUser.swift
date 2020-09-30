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
        self.username = "User №" + user.uid.prefix(3)
        self.email = user.email!
    }
}
