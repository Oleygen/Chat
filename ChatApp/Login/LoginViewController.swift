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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModel.view = self
    }
    
    @IBAction func createAccountButtonAction(_ sender: Any) {
        
        // debug
        #warning("only for debug")
        didCreateAccount()
        
        
//        guard let email = emailTextField.text, !email.isEmpty else {
//            showAlert()
//            return
//        }
//        guard let password = getPassword() else {
//            showAlert()
//            return
//        }
//        loginModel.createAccount(email: email,
//                                 password: password)
    }
    
    func didCreateAccount() {
        let chatViewController = ChatViewController()
        chatViewController.modalPresentationStyle = .fullScreen
        present(chatViewController, animated:true, completion:nil)
    }
        
    func showError() {
        showAlert()
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

