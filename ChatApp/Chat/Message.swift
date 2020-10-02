//
//  Message.swift
//  ChatApp
//
//  Created by Den on 2020-09-30.
//  Copyright © 2020 Den. All rights reserved.
//

import Foundation

struct Message: Codable {
    let senderName: String
    let timestamp: String
    let userEmail: String
    let message: String
}
