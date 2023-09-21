//
//  SettingViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class SettingViewController: UIViewController, UITextFieldDelegate {
    
    let signUpTitleLabel = TitleLabel(frame: .zero, text: "設定変更")
    let iconImageView = CustomButton(frame: .zero, cornerRadius: 75, systemName: "camera")
    let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID", paddingSize: 0)
    let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp", paddingSize: 0)
    let nameLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "名前", paddingSize: 0)
    let nameTextField = CustomTextField(frame: .zero, placeholder: "名前", paddingSize: 0)
    let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード", paddingSize: 0)
    let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード", paddingSize: 0)
    let repasswordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード(確認)", paddingSize: 0)
    let repasswordTextField = CustomTextField(frame: .zero, placeholder: "パスワード(確認)", paddingSize: 0)
    let loginSelectButton = SelectButton(frame: .zero, title: "修正")
    
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
        loginSelectButton.isEnabled = false
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
        view.addSubview(loginSelectButton)
        // 制約設定
        SettingViewConstraints.makeConstraints(view: view, iconImageView: iconImageView, signUpTitleLabel: signUpTitleLabel, idLabel: idLabel, idTextField: idTextField, nameLabel: nameLabel, nameTextField: nameTextField, passwordLabel: passwordLabel, passwordTextField: passwordTextField, repasswordLabel: repasswordLabel, repasswordTextField: repasswordTextField, loginSelectButton: loginSelectButton)
        // キーボード設定用
        idTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        repasswordTextField.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let nameIsEmpty = nameTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let repasswordIsEmpty = repasswordTextField.text?.isEmpty ?? true
        
        if idIsEmpty || nameIsEmpty || passwordIsEmpty || repasswordIsEmpty {
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
