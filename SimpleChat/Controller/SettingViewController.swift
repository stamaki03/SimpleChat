//
//  SettingViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class SettingViewController: UIViewController {
    // MARK: - Properties
    private let signUpTitleLabel = CustomLabel(frame: .zero, fontSize: 40, text: "設定変更", textAlignment: .center, paddingSize: 0)
    private let iconImageView = CustomButton(frame: .zero, cornerRadius: 75, systemName: "person")
    private let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID", textAlignment: .left, paddingSize: 0)
    private let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp", paddingSize: 0)
    private let nameLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "名前", textAlignment: .left, paddingSize: 0)
    private let nameTextField = CustomTextField(frame: .zero, placeholder: "名前", paddingSize: 0)
    private let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード", textAlignment: .left, paddingSize: 0)
    private let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード", paddingSize: 0)
    private let repasswordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード(確認)", textAlignment: .left, paddingSize: 0)
    private let repasswordTextField = CustomTextField(frame: .zero, placeholder: "パスワード(確認)", paddingSize: 0)
    private let modifyButton = CustomSelectButton(frame: .zero, title: "修正", backgroundcolor: .lightGray, borderColor: UIColor.clear.cgColor, borderWidth: 0, foregroundcolor: .white)
    
    private let imagePicker = UIImagePickerController()
    
    private var image: UIImage?
    private var localImageURL: URL?
    
    // MARK: - SetUp
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        setButtonAction()
        setBarItem()
        // イメージピッカー設定
        imagePicker.delegate = self
    }
    
    private func setView() {
        view.backgroundColor = .white
        idTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        repasswordTextField.delegate = self
        modifyButton.isEnabled = false
        idTextField.tag = 0
        nameTextField.tag = 1
        passwordTextField.tag = 2
        repasswordTextField.tag = 3
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
        view.addSubview(modifyButton)
        // 制約設定
        SettingViewConstraints.makeConstraints(view: view, iconImageView: iconImageView, signUpTitleLabel: signUpTitleLabel, idLabel: idLabel, idTextField: idTextField, nameLabel: nameLabel, nameTextField: nameTextField, passwordLabel: passwordLabel, passwordTextField: passwordTextField, repasswordLabel: repasswordLabel, repasswordTextField: repasswordTextField, modifyButton: modifyButton)
        // 暗号化設定
        passwordTextField.isSecureTextEntry = true
        repasswordTextField.isSecureTextEntry = true
    }
    
    private func setButtonAction() {
        iconImageView.addTarget(self, action: #selector(registerImage(sender:)), for:.touchUpInside)
        modifyButton.addTarget(self, action: #selector(userModify(sender:)), for:.touchUpInside)
    }
    
    private func setBarItem() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(backView))
        navigationItem.leftBarButtonItems = [backButton]
        let registerButton = UIBarButtonItem(title: "アカウント削除", style: .plain, target: self, action: #selector(deleteAccount))
        navigationItem.rightBarButtonItems = [registerButton]
    }
    
    // MARK: - Actions
    @objc internal func registerImage(sender: UIButton){
        if self.image == nil {
            self.present(imagePicker, animated:true, completion:nil)
        } else {
            self.iconImageView.setImage(UIImage(systemName: "person"), for: .normal)
            self.image = nil
            inputValidate(image: true, id: true, name: true, password: true)
            modifyButton.buttonInvalidate()
        }
    }
    
    @objc internal func userModify(sender: UIButton){
        Task {
            do {
                if let image = image {
                    try await changePhoto(image: image)
                } else if idTextField.text != "" {
                    try await changeEmail()
                } else if nameTextField.text != "" {
                    try changeName()
                } else if passwordTextField.text != "" {
                    try await changePassword()
                }
            } catch {
                let alert = AlertMessage.shared.notificationAlert(message: "エラーが発生しました")
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func changePhoto(image: UIImage) async throws {
        try await StorageManager.shared.updateImage(image: image)
        self.navigationController?.popViewController(animated: false)
        let alert = AlertMessage.shared.notificationAlertWithDismiss(message: "プロフィール画像を変更しました")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func changeEmail() async throws {
        guard let email = idTextField.text else { return }
        try await AuthenticationManager.shared.updateEmail(email: email)
        //try UserManager.shared.changeUserEmail(email: email)
        let alert = AlertMessage.shared.notificationAlertWithDismiss(message: "IDを変更しました")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func changeName() throws {
        guard let name = nameTextField.text else { return }
        try UserManager.shared.changeUserName(name: name)
        let alert = AlertMessage.shared.notificationAlertWithDismiss(message: "名前を変更しました")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func changePassword() async throws {
        guard let password = passwordTextField.text, let repassword = repasswordTextField.text else { return }
        if password != repassword {
            let alert = AlertMessage.shared.notificationAlert(message: "パスワードが一致してません")
            present(alert, animated: true, completion: nil)
            return
        }
        if password.count < 8 {
            let alert = AlertMessage.shared.notificationAlert(message: "パスワードは8文字以上入力してください")
            present(alert, animated: true, completion: nil)
            return
        }
        try await AuthenticationManager.shared.updatePassword(password: password)
        let alert = AlertMessage.shared.notificationAlertWithDismiss(message: "パスワードを変更しました")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc internal func backView() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc internal func deleteAccount() {
        let alert = AlertMessage.shared.confirmationAlert(message: "アカウント削除してよろしいですか？")
        alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { _ in
            guard let currentUser = AuthenticationManager.shared.getcurrentUser() else { return }
            StorageManager.shared.deleteImage(userId: currentUser.uid)
            UserManager.shared.deleteUser(userId: currentUser.uid)
            AuthenticationManager.shared.deleteUser(currentUser: currentUser)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func inputValidate(image: Bool, id: Bool, name: Bool, password: Bool) {
        iconImageView.isEnabled = image
        iconImageView.backgroundColor = image ? .white : .lightGray
        idTextField.isEnabled = id
        idTextField.backgroundColor  = id ? .white : .lightGray
        nameTextField.isEnabled = name
        nameTextField.backgroundColor  = name ? .white : .lightGray
        passwordTextField.isEnabled = password
        passwordTextField.backgroundColor  = password ? .white : .lightGray
        repasswordTextField.isEnabled = password
        repasswordTextField.backgroundColor  = password ? .white : .lightGray
    }
}

// MARK: - Extensions
extension SettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let nameIsEmpty = nameTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let repasswordIsEmpty = repasswordTextField.text?.isEmpty ?? true
        
        if !idIsEmpty {
            inputValidate(image: false, id: true, name: false, password: false)
            modifyButton.buttonValidate()
        } else if !nameIsEmpty {
            inputValidate(image: false, id: false, name: true, password: false)
            modifyButton.buttonValidate()
        } else if !passwordIsEmpty {
            inputValidate(image: false, id: false, name: false, password: true)
            modifyButton.buttonValidate()
        } else if !repasswordIsEmpty {
            inputValidate(image: false, id: false, name: false, password: true)
            modifyButton.buttonValidate()
        } else {
            inputValidate(image: true, id: true, name: true, password: true)
            modifyButton.buttonInvalidate()
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

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            iconImageView.setImage(editedImage, for: .normal)
            self.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            iconImageView.setImage(originalImage, for: .normal)
            self.image = originalImage
        }
        dismiss(animated: true, completion: nil)
        self.localImageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        //
        inputValidate(image: true, id: false, name: false, password: false)
        modifyButton.buttonValidate()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
