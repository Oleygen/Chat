//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Den on 2020-09-29.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    let chatModel = ChatModel()
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var burgerMenuView: UIView!
    @IBOutlet weak var messageTexField: UITextField!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatModel.view = self
        setupTableView()
        setupGestures()
        setupButtons()
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "MessageTableViewCell")
        chatTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        guard let message = messageTexField.text, !message.isEmpty else { return }
        chatModel.send(message: message)
        messageTexField.text = nil
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        chatModel.signOut()
    }
    
    func didReceive(messages: [Message]) {
        self.messages = messages
        chatTableView.reloadData()
        chatTableView.scrollToBottomRow()
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
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            burgerMenu(show: false)
        }
        if (sender.direction == .right) {
            burgerMenu(show: true)
        }
    }
    
    private func setupButtons() {
        settingsButton.setBorder()
        logoutButton.setBorder()
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        cell.configureCell(isMy: false, messages[indexPath.row])
        return cell
    }
    
}
