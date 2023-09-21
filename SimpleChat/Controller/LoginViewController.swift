//
//  LoginViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @Published private var validCheck1 = false
    @Published private var validCheck2 = false
    
    let appTitleLabel = TitleLabel(frame: .zero, text: "SIMPLE CHAT")
    let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID")
    let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp")
    let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード")
    let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード")
    let loginSelectButton = SelectButton(frame: .zero, title: "ログイン")
    let signUpButton = ExplanationButton(frame: .zero, title: "新規登録はこちら")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // ビュー設定
        view.backgroundColor = .white
        // サブビュー設定
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
        // ボタンアクション設定
        loginSelectButton.addTarget(self, action: #selector(goToMainViewController(sender:)), for:.touchUpInside)
        signUpButton.addTarget(self, action: #selector(goToSignUpViewController(sender:)), for:.touchUpInside)
        // キーボード設定用
        idTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // ボタンアクション処理
    @objc internal func goToMainViewController(sender: UIButton){
        Auth.auth().signIn(withEmail: idTextField.text ?? "" , password: passwordTextField.text ?? "") { [weak self] authResult, error in
            guard let self = self else { return }
            if let e = error {
                print(e)
            } else {
                let mainViewController = MainViewController()
                self.navigationController?.pushViewController(mainViewController, animated: true)
                return
            }
        }
    }
    
    @objc internal func goToSignUpViewController(sender: UIButton){
        let signUpViewController = SignUpViewController()
        self.navigationController?.present(signUpViewController, animated: true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if idIsEmpty || passwordIsEmpty {
            loginSelectButton.isEnabled = false
            loginSelectButton.backgroundColor = .lightGray
        } else {
            loginSelectButton.isEnabled = true
            loginSelectButton.backgroundColor = UIColor(named: "bg")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
