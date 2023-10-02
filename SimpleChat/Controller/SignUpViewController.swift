//
//  SignUpViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class SignUpViewController: UIViewController {
    // MARK: - Properties
    private let signUpTitleLabel = CustomLabel(frame: .zero, fontSize: 40, text: "新規登録", textAlignment: .center, paddingSize: 0)
    private let iconImageView = CustomButton(frame: .zero, cornerRadius: 75, systemName: "person")
    private let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID", textAlignment: .left, paddingSize: 0)
    private let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp", paddingSize: 0)
    private let nameLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "名前", textAlignment: .left, paddingSize: 0)
    private let nameTextField = CustomTextField(frame: .zero, placeholder: "名前", paddingSize: 0)
    private let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード", textAlignment: .left, paddingSize: 0)
    private let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード", paddingSize: 0)
    private let repasswordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード(確認)", textAlignment: .left, paddingSize: 0)
    private let repasswordTextField = CustomTextField(frame: .zero, placeholder: "パスワード(確認)", paddingSize: 0)
    private let signUpButton = SelectButton(frame: .zero, title: "登録", backgroundcolor: .lightGray, borderColor: UIColor.clear.cgColor, borderWidth: 0, foregroundcolor: .white)
    
    private let imagePicker = UIImagePickerController()
    
    private var image: UIImage?
    private var localImageURL: URL?
    
    // MARK: - SetUp
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        setButtonAction()
        // イメージピッカー設定
        imagePicker.delegate = self
    }
    
    private func setView() {
        view.backgroundColor = .white
        idTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        repasswordTextField.delegate = self
        signUpButton.isEnabled = false
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
        view.addSubview(signUpButton)
        // 制約設定
        SignUpViewConstraints.makeConstraints(view: view, iconImageView: iconImageView, signUpTitleLabel: signUpTitleLabel, idLabel: idLabel, idTextField: idTextField, nameLabel: nameLabel, nameTextField: nameTextField, passwordLabel: passwordLabel, passwordTextField: passwordTextField, repasswordLabel: repasswordLabel, repasswordTextField: repasswordTextField, signUpButton: signUpButton)
        // 暗号化設定
        passwordTextField.isSecureTextEntry = true
        repasswordTextField.isSecureTextEntry = true
    }
    
    private func setButtonAction() {
        iconImageView.addTarget(self, action: #selector(registerImage(sender:)), for:.touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpUser(sender:)), for:.touchUpInside)
    }
    
    // MARK: - Actions
    @objc internal func registerImage(sender: UIButton){
        if self.image == nil {
            self.present(imagePicker, animated:true, completion:nil)
        } else {
            self.iconImageView.setImage(UIImage(systemName: "person"), for: .normal)
            self.image = nil
        }
    }
        
    @objc internal func signUpUser(sender: UIButton){
        Task {
            do {
                signUpButton.buttonInvalidate()
                var downloadUrl: String?
                guard let email = idTextField.text, let name = nameTextField.text, let password = passwordTextField.text, let repassword = repasswordTextField.text else { return }
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
                let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
                if let uploadImage = self.image?.jpegData(compressionQuality: 0.1) {
                    downloadUrl = try await StorageManager.shared.saveImage(data: uploadImage, userId: authDataResult.uid)
                }
                try await UserManager.shared.createUser(auth: authDataResult, name: name, photoUrl: downloadUrl ?? "")
                self.dismiss(animated: true, completion: nil)
            } catch {
                let errMessage = FAErrorCheck.shared.signUpValidationCheck(error: error)
                let alert = AlertMessage.shared.notificationAlert(message: errMessage)
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Extensions
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let nameIsEmpty = nameTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let repasswordIsEmpty = repasswordTextField.text?.isEmpty ?? true
        
        if idIsEmpty || nameIsEmpty || passwordIsEmpty || repasswordIsEmpty {
            signUpButton.buttonInvalidate()
        } else {
            signUpButton.buttonValidate()
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

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
