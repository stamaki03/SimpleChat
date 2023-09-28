//
//  LoginViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class LoginViewController: UIViewController {
    let appTitleLabel = TitleLabel(frame: .zero, text: "SIMPLE CHAT")
    let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID", paddingSize: 0)
    let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp", paddingSize: 0)
    let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード", paddingSize: 0)
    let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード", paddingSize: 0)
    let loginSelectButton = SelectButton(frame: .zero, title: "ログイン")
    let signUpButton = ExplanationButton(frame: .zero, title: "新規登録はこちら")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        setButtonAction()
    }
    
    private func setView() {
        view.backgroundColor = .white
        idTextField.delegate = self
        passwordTextField.delegate = self
        loginSelectButton.isEnabled = false
        view.addSubview(appTitleLabel)
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginSelectButton)
        view.addSubview(signUpButton)
        // 制約設定
        LoginViewConstraints.makeConstraints(view: view, appTitleLabel: appTitleLabel, idLabel: idLabel, idTextField: idTextField, passwordLabel: passwordLabel, passwordTextField: passwordTextField, loginSelectButton: loginSelectButton, signUpButton: signUpButton)
        // 暗号化設定
        passwordTextField.isSecureTextEntry = true
    }
    
    private func setButtonAction() {
        loginSelectButton.addTarget(self, action: #selector(goToMainViewController(sender:)), for:.touchUpInside)
        signUpButton.addTarget(self, action: #selector(goToSignUpViewController(sender:)), for:.touchUpInside)
    }
    
    private func buttonValidate() {
        loginSelectButton.isEnabled = true
        loginSelectButton.backgroundColor = UIColor(named: "bg")
    }
    
    private func buttonInvalidate() {
        loginSelectButton.isEnabled = false
        loginSelectButton.backgroundColor = .lightGray
    }
    
    @objc internal func goToMainViewController(sender: UIButton){
        Task {
            do {
                buttonInvalidate()
                guard let email = idTextField.text, let password = passwordTextField.text else { return }
                if password.count < 8 {
                    let alert = AlertMessage.shared.notificationAlert(message: "パスワードは8文字以上入力してください")
                    present(alert, animated: true, completion: nil)
                    return
                }
                try await AuthenticationManager.shared.signInUser(email: email, password: password)
                let mainViewController = MainViewController()
                self.navigationController?.pushViewController(mainViewController, animated: false)
                buttonValidate()
            } catch {
                buttonValidate()
                let errMessage = FAErrorCheck.shared.loginValidationCheck(error: error)
                let alert = AlertMessage.shared.notificationAlert(message: errMessage)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc internal func goToSignUpViewController(sender: UIButton){
        let signUpViewController = SignUpViewController()
        self.navigationController?.present(signUpViewController, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if idIsEmpty || passwordIsEmpty {
            buttonInvalidate()
        } else {
            buttonValidate()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
