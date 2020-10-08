//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Den on 2020-09-29.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private lazy var chatModel = ChatModel(view: self)
    weak var coordinator: MainCoordinator?
    
    private var chatUser: ChatUser!
    
    @IBOutlet private weak var chatTableView: UITableView!
    @IBOutlet private weak var burgerMenuView: UIView!
    @IBOutlet private weak var messageTexField: UITextField!
    
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    
    @IBOutlet private weak var profileUsernameLabel: UILabel!
    @IBOutlet private weak var profileEmailLabel: UILabel!
    @IBOutlet private weak var profileUsernameAvatarImage: UIImageView!
    @IBOutlet private weak var usernameInitialsLabel: UILabel!
    
    @IBOutlet private weak var keyboardConstraint: NSLayoutConstraint!
    
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = chatModel
        setupTableView()
        setupGestures()
        setupButtons()
        profileUsernameAvatarImage.setBorder()
        registerKeyboardEvents()
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "MessageTableViewCell")
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func setupGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        view.addGestureRecognizer(touch)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        guard let message = messageTexField.text, !message.isEmpty else { return }
        chatModel.send(message: message, user: chatUser)
        messageTexField.text = nil
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        coordinator?.showSettings(chatUser: chatUser)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
//        chatModel.signOut()
        dismiss(animated: true)
        coordinator?.dismiss()
    }
    
    func didReceive(allMessages: [Message]) {
        self.messages = allMessages
        chatTableView.reloadData()
        chatTableView.scrollToBottomRow()
    }
    
    func didReceive(newMessages: [Message]) {
        self.messages.append(contentsOf: newMessages)
        chatTableView.reloadData()
        chatTableView.scrollToBottomRow()
    }
    
    func setupUser(_ user: ChatUser) {
        profileUsernameLabel.text = user.name
        profileEmailLabel.text = user.email
        usernameInitialsLabel.text = String(user.name.prefix(2))
        chatUser = user
    }
    
    func setupUserAvatar(_ image: UIImage) {
        profileUsernameAvatarImage.image = image
        chatUser.avatar = image
        usernameInitialsLabel.isHidden = true
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
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
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
    
    
    // MARK: - Keyboard
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
    
    private func registerKeyboardEvents() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(ChatViewController.keyboardWillShow),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(ChatViewController.keyboardWillHide),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification
                    .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        keyboardConstraint.constant = -keyboardHeight
        UIView.animate(withDuration: 0.5,
                       animations: { self.view.layoutIfNeeded() },
                       completion: { _ in
            self.chatTableView.scrollToBottomRow()
        })
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as? MessageTableViewCell {
            cell.configureCell(isMy: messages[indexPath.row].userEmail == chatUser.email,
                               messages[indexPath.row])
            return cell
        }
        assert(false)
        return UITableViewCell()
    }
    
}
