//
//  MainCoordinator.swift
//  ChatApp
//
//  Created by Den on 2020-10-08.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let vc = LoginViewController.instantiate() else {
            assert(false)
            return
        }
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showChat() {
        let chatViewController = ChatViewController()
        chatViewController.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(chatViewController,
                                                animated: true)
    }
    
    func showSettings(chatUser: ChatUser) {
        guard let chatvc = self.navigationController.viewControllers
                               .item(at: 1) as? ChatViewController else {
            assert(false)
            return
        }
        let settingsViewController = SettingsViewController()
        settingsViewController.updateUserAction = { user in
            chatvc.setupUser(user)
        }
        settingsViewController.updateUserAvatarAction = { image in
            chatvc.setupUserAvatar(image)
        }
        settingsViewController.setupUser(chatUser)
        settingsViewController.modalPresentationStyle = .popover
        navigationController.present(settingsViewController, animated: true)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
