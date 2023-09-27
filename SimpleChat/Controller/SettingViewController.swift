//
//  SettingViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit
import FirebaseAuth

final class SettingViewController: UIViewController {
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
    let modifyButton = SelectButton(frame: .zero, title: "修正")
    
    let imagePicker = UIImagePickerController()
    
    var image: UIImage?
    var localImageURL: URL?
    
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
    
    private func buttonValidate() {
        modifyButton.isEnabled = true
        modifyButton.backgroundColor = UIColor(named: "bg")
    }
    
    private func buttonInvalidate() {
        modifyButton.isEnabled = false
        modifyButton.backgroundColor = .lightGray
    }
    
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
    
    
    @objc internal func registerImage(sender: UIButton){
        if self.image == nil {
            self.present(imagePicker, animated:true, completion:nil)
        } else {
            self.iconImageView.setImage(UIImage(systemName: "camera"), for: .normal)
            self.image = nil
            inputValidate(image: true, id: true, name: true, password: true)
            buttonInvalidate()
        }
    }
    
    @objc internal func userModify(sender: UIButton){
        if let image = image {
            
        } else if let id = idTextField.text {
            
        } else if let name = nameTextField.text {
            
        } else if let password = passwordTextField.text {
            
        }
    }
    
    @objc internal func backView() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc internal func deleteAccount() {
        let alert = AlertMessage.shared.confirmationAlert(message: "アカウント削除してよろしいですか？")
        alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { _ in
            guard let currentUser = Auth.auth().currentUser else { return }
            StorageManager.shared.deleteImage(userId: currentUser.uid)
            UserManager.shared.deleteUser(userId: currentUser.uid)
            AuthenticationManager.shared.deleteUser(currentUser: currentUser)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension SettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let nameIsEmpty = nameTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let repasswordIsEmpty = repasswordTextField.text?.isEmpty ?? true
        
        if !idIsEmpty {
            inputValidate(image: false, id: true, name: false, password: false)
            buttonValidate()
        } else if !nameIsEmpty {
            inputValidate(image: false, id: false, name: true, password: false)
            buttonValidate()
        } else if !passwordIsEmpty {
            inputValidate(image: false, id: false, name: false, password: true)
            buttonValidate()
        } else if !repasswordIsEmpty {
            inputValidate(image: false, id: false, name: false, password: true)
            buttonValidate()
        } else {
            inputValidate(image: true, id: true, name: true, password: true)
            buttonInvalidate()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        buttonValidate()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
