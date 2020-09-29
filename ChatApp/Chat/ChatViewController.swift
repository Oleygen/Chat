//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Den on 2020-09-29.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var burgerMenuView: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        burgerMenu(show: true)
    }
    
    @IBAction func burgerDebugButton(_ sender: Any) {
        burgerMenu(show: false)
    }
    
    private func burgerMenu(show: Bool) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        if show {
            if !burgerMenuView.isHidden { return }
            transition.subtype = CATransitionSubtype.fromLeft
            burgerMenuView.layer.add(transition, forKey: kCATransition)
            burgerMenuView.isHidden = false
        } else {
            if burgerMenuView.isHidden { return }
            transition.subtype = CATransitionSubtype.fromRight
            burgerMenuView.layer.add(transition, forKey: kCATransition)
            burgerMenuView.isHidden = true
        }
    }

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
