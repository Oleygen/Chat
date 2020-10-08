//
//  Storyboarded.swift
//  ChatApp
//
//  Created by Den on 2020-10-08.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self?
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self? {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: className) as? Self
        return vc
    }
}
