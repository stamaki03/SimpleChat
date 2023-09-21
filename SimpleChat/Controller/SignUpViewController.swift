//
//  SignUpViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit
import FirebaseAuth

final class SignUpViewController: UIViewController {
    
    let signUpTitleLabel = TitleLabel(frame: .zero, text: "新規登録")
    let iconImageView = CustomButton(frame: .zero, cornerRadius: 75, systemName: "camera")
    let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID")
    let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp")
    let nameLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "名前")
    let nameTextField = CustomTextField(frame: .zero, placeholder: "名前")
    let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード")
    let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード")
    let repasswordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード(確認)")
    let repasswordTextField = CustomTextField(frame: .zero, placeholder: "パスワード(確認)")
    let signUpButton = SelectButton(frame: .zero, title: "登録")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // ビュー設定
        view.backgroundColor = .white
        // サブビュー設定
        idTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        repasswordTextField.delegate = self
        signUpButton.isEnabled = false
        view.addSubview(signUpTitleLabel)
        view.addSubview(iconImageView)
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(repasswordLabel)
        view.addSubview(repasswordTextField)
        view.addSubview(signUpButton)
        // 制約設定
        SignUpViewConstraints.makeConstraints(view: view, iconImageView: iconImageView, signUpTitleLabel: signUpTitleLabel, idLabel: idLabel, idTextField: idTextField, nameLabel: nameLabel, nameTextField: nameTextField, passwordLabel: passwordLabel, passwordTextField: passwordTextField, repasswordLabel: repasswordLabel, repasswordTextField: repasswordTextField, signUpButton: signUpButton)
        // ボタンアクション設定
        signUpButton.addTarget(self, action: #selector(signUpUser(sender:)), for:.touchUpInside)
    }
    
    @objc internal func signUpUser(sender: UIButton){
        Auth.auth().createUser(withEmail: idTextField.text ?? "", password: passwordTextField.text ?? "") { authResult, error in
            if let e = error {
                print(e)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let nameIsEmpty = nameTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let repasswordIsEmpty = repasswordTextField.text?.isEmpty ?? true
        
        if idIsEmpty || nameIsEmpty || passwordIsEmpty || repasswordIsEmpty {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .lightGray
        } else {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(named: "bg")
        }
    }
}
