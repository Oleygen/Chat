//
//  ViewController.swift
//  ChatApp
//
//  Created by Den on 2020-09-29.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginModel = LoginModel()
    
    // Registration
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var createAccountTabbarButton: UIButton!
    @IBOutlet weak var signinTabbarButton: UIButton!
    
    // Signin
    @IBOutlet weak var signinEmailTextField: UITextField!
    @IBOutlet weak var signinPasswordTextField: UITextField!
    @IBOutlet weak var signinTextFieldsView: UIView!
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModel.view = self
        createAccountButton.setBorder()
        signinButton.setBorder()
        signinTextFieldsView.isHidden = true
        disableSigninTabbarButton()
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
        signinTextFieldsView.isHidden = true
        disableSigninTabbarButton()
    }
    
    @IBAction func signinScreenButtonAction(_ sender: Any) {
        signinTextFieldsView.isHidden = false
        disableCreateAccountTabbarButton()
    }
    
    private func disableCreateAccountTabbarButton() {
        createAccountTabbarButton.tintColor = UIColor.white.withAlphaComponent(0.5)
        signinTabbarButton.tintColor = .white
    }
    
    private func disableSigninTabbarButton() {
        createAccountTabbarButton.tintColor = .white
        signinTabbarButton.tintColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func successSignIn(email: String) {
        presentChatViewController(email: email)
    }
        
    func showError() {
        showAlert()
    }
    
    private func presentChatViewController(email: String) {
        let chatViewController = ChatViewController()
        chatViewController.userEmail = email
        chatViewController.modalPresentationStyle = .fullScreen
        present(chatViewController, animated:true, completion: nil)
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
    
}

