//
//  ViewController.swift
//  ChatApp
//
//  Created by Den on 2020-09-29.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let loginModel = LoginModel()
    
    // Registration
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    @IBOutlet private weak var createAccountTabbarButton: UIButton!
    @IBOutlet private weak var signinTabbarButton: UIButton!
    @IBOutlet private weak var createAccountView: UIView!
    
    // Signin
    @IBOutlet private weak var signinEmailTextField: UITextField!
    @IBOutlet private weak var signinPasswordTextField: UITextField!
    @IBOutlet private weak var signinTextFieldsView: UIView!
    @IBOutlet private weak var signinButton: UIButton!
    
    // Keyboard
    @IBOutlet private weak var keyboardConstraint: NSLayoutConstraint!
    private var isKeyboardOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModel.view = self
        createAccountButton.setBorder()
        signinButton.setBorder()
        signinTextFieldsView.isHidden = true
        disableSigninTabbarButton()
        registerKeyboardEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Firebase.Auth.auth().currentUser != nil {
            presentChatViewController()
        }
    }
    
    @IBAction func createAccountButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert()
            return
        }
        guard let password = getPassword() else {
            showAlert()
            return
        }
        loginModel.createAccount(email: email,
                                 password: password)
    }
    
    @IBAction func signinButtonAction(_ sender: Any) {
        guard let email = signinEmailTextField.text, !email.isEmpty else {
            showAlert()
            return
        }
        guard let password = signinPasswordTextField.text, !password.isEmpty else {
            showAlert()
            return
        }
        loginModel.signIn(email: email, password: password)
    }
    
    @IBAction func createAccountScreenButtonAction(_ sender: Any) {
        if !createAccountView.isHidden { return }
        hideSignIn()
        showCreateAccount()
        disableSigninTabbarButton()
    }
    
    @IBAction func signinScreenButtonAction(_ sender: Any) {
        if !signinTextFieldsView.isHidden { return }
        showSignIn()
        hideCreateAccount()
        disableCreateAccountTabbarButton()
    }
    
    
    // MARK: - Animations
    
    private func createAnimation() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        return transition
    }
    
    private func hideSignIn() {
        let transition = createAnimation()
        transition.subtype = CATransitionSubtype.fromLeft
        signinTextFieldsView.layer.add(transition, forKey: kCATransition)
        signinTextFieldsView.isHidden = true
    }
    
    private func showSignIn() {
        let transition = createAnimation()
        transition.subtype = CATransitionSubtype.fromRight
        signinTextFieldsView.layer.add(transition, forKey: kCATransition)
        signinTextFieldsView.isHidden = false
    }
    
    private func showCreateAccount() {
        let transition = createAnimation()
        transition.subtype = CATransitionSubtype.fromLeft
        createAccountView.layer.add(transition, forKey: kCATransition)
        createAccountView.isHidden = false
    }
    
    private func hideCreateAccount() {
        let transition = createAnimation()
        transition.subtype = CATransitionSubtype.fromRight
        createAccountView.layer.add(transition, forKey: kCATransition)
        createAccountView.isHidden = true
    }
    
    
    // MARK: -
    
    private func disableCreateAccountTabbarButton() {
        createAccountTabbarButton.tintColor = UIColor.white.withAlphaComponent(0.5)
        signinTabbarButton.tintColor = .white
    }
    
    private func disableSigninTabbarButton() {
        createAccountTabbarButton.tintColor = .white
        signinTabbarButton.tintColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func successSignIn() {
        presentChatViewController()
    }
        
    func showError() {
        showAlert()
    }
    
    private func presentChatViewController() {
        let chatViewController = ChatViewController()
        chatViewController.modalPresentationStyle = .overCurrentContext
        present(chatViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Private
    
    private func getPassword() -> String? {
        guard let password = passwordTextField.text,
                  !password.isEmpty else { return nil }
        guard let confirmPassword = confirmPasswordTextField.text,
                  !confirmPassword.isEmpty else { return nil }
        guard password == confirmPassword else { return nil }
        return password
    }
    
    private func showAlert(_ message: String = "Try later") {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func registerKeyboardEvents() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(LoginViewController.keyboardWillShow),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(LoginViewController.keyboardWillHide),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if isKeyboardOpened { return }
        guard let keyboardFrame = notification
                    .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardAccesoryViewHeight: CGFloat = 30
        let keyboardHeight = keyboardRectangle.height + keyboardAccesoryViewHeight
        keyboardConstraint.constant = -keyboardHeight
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        isKeyboardOpened = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        isKeyboardOpened = false
    }
    
}
