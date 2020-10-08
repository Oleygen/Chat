//
//  Coordinator.swift
//  ChatApp
//
//  Created by Den on 2020-10-08.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    
}
