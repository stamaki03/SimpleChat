//
//  LoginViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private let appTitleLabel = TitleLabel(frame: .zero, text: "SIMPLE CHAT")
    private let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID", paddingSize: 0)
    private let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp", paddingSize: 0)
    private let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード", paddingSize: 0)
    private let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード", paddingSize: 0)
    private let loginSelectButton = SelectButton(frame: .zero, title: "ログイン", backgroundcolor: .lightGray, borderColor: UIColor.clear.cgColor, borderWidth: 0, foregroundcolor: .white)
    private let signUpButton = SelectButton(frame: .zero, title: "新規登録", backgroundcolor: .clear, borderColor: (UIColor(named: "bg") ?? .white).cgColor, borderWidth: 1, foregroundcolor: UIColor(named: "bg") ?? .black)
    private let resetPasswordButton = SelectButton(frame: .zero, title: "パスワードリセット", backgroundcolor: UIColor.clear, borderColor: UIColor.clear.cgColor, borderWidth: 0, foregroundcolor: UIColor(named: "bg") ?? .black)
    
    // MARK: - SetUp
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
        idTextField.tag = 0
        passwordTextField.tag = 1
        view.addSubview(appTitleLabel)
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginSelectButton)
        view.addSubview(signUpButton)
        view.addSubview(resetPasswordButton)
        // 制約設定
        LoginViewConstraints.makeConstraints(view: view, appTitleLabel: appTitleLabel, idLabel: idLabel, idTextField: idTextField, passwordLabel: passwordLabel, passwordTextField: passwordTextField, loginSelectButton: loginSelectButton, signUpButton: signUpButton, resetPasswordButton: resetPasswordButton)
        // 暗号化設定
        passwordTextField.isSecureTextEntry = true
    }
    
    private func setButtonAction() {
        loginSelectButton.addTarget(self, action: #selector(goToMainViewController(sender:)), for:.touchUpInside)
        signUpButton.addTarget(self, action: #selector(goToSignUpViewController(sender:)), for:.touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPassword(sender:)), for:.touchUpInside)
    }
    
    // MARK: - Actions
    @objc internal func goToMainViewController(sender: UIButton){
        Task {
            do {
                loginSelectButton.buttonInvalidate()
                guard let email = idTextField.text, let password = passwordTextField.text else { return }
                if password.count < 8 {
                    let alert = AlertMessage.shared.notificationAlert(message: "パスワードは8文字以上入力してください")
                    present(alert, animated: true, completion: nil)
                    return
                }
                try await AuthenticationManager.shared.signInUser(email: email, password: password)
                let mainViewController = MainViewController()
                self.navigationController?.pushViewController(mainViewController, animated: false)
                loginSelectButton.buttonValidate()
            } catch {
                loginSelectButton.buttonValidate()
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
    
    @objc internal func resetPassword(sender: UIButton){
        let remindPasswordAlert = AlertMessage.shared.resetPasswordAlert()
        remindPasswordAlert.addAction(UIAlertAction(title: "リセット", style: .default, handler: { (action) in
            let resetEmail = remindPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                Task.detached { @MainActor in
                    if let _ = error {
                        let alert = AlertMessage.shared.notificationAlert(message: "このメールアドレスは登録されてません。")
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = AlertMessage.shared.notificationAlert(message: "メールでパスワードの再設定を行ってください。")
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }))
        self.present(remindPasswordAlert, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if idIsEmpty || passwordIsEmpty {
            loginSelectButton.buttonInvalidate()
        } else {
            loginSelectButton.buttonValidate()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
