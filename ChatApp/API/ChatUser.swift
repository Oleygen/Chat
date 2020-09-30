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
    let username: String? = nil
    let email: String
    
    init(_ user: User) {
        self.email = user.email!
    }
}
