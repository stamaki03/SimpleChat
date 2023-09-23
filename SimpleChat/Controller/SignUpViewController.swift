//
//  SignUpViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    let signUpTitleLabel = TitleLabel(frame: .zero, text: "新規登録")
    let iconImageView = CustomButton(frame: .zero, cornerRadius: 75, systemName: "camera")
    let deleteImage = CustomButton(frame: .zero, cornerRadius: 0, systemName: "trash")
    let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID", paddingSize: 0)
    let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp", paddingSize: 0)
    let nameLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "名前", paddingSize: 0)
    let nameTextField = CustomTextField(frame: .zero, placeholder: "名前", paddingSize: 0)
    let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード", paddingSize: 0)
    let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード", paddingSize: 0)
    let repasswordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード(確認)", paddingSize: 0)
    let repasswordTextField = CustomTextField(frame: .zero, placeholder: "パスワード(確認)", paddingSize: 0)
    let signUpButton = SelectButton(frame: .zero, title: "登録")
    
    let ipc = UIImagePickerController()
    var image: UIImage?
    var localImageURL: URL?
    
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
        view.addSubview(deleteImage)
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
        SignUpViewConstraints.makeConstraints(view: view, iconImageView: iconImageView, deleteImage: deleteImage, signUpTitleLabel: signUpTitleLabel, idLabel: idLabel, idTextField: idTextField, nameLabel: nameLabel, nameTextField: nameTextField, passwordLabel: passwordLabel, passwordTextField: passwordTextField, repasswordLabel: repasswordLabel, repasswordTextField: repasswordTextField, signUpButton: signUpButton)
        // ボタンアクション設定
        iconImageView.addTarget(self, action: #selector(registerImage(sender:)), for:.touchUpInside)
        deleteImage.addTarget(self, action: #selector(deleteImage(sender:)), for:.touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpUser(sender:)), for:.touchUpInside)
        // イメージピッカー設定
        ipc.delegate = self
    }
    
    @objc internal func registerImage(sender: UIButton){
        self.present(ipc, animated:true, completion:nil)
    }
    
    @objc internal func deleteImage(sender: UIButton){
        self.iconImageView.setImage(UIImage(systemName: "camera"), for: .normal)
        self.image = nil
    }
    
    @objc internal func signUpUser(sender: UIButton){
        Task {
            do {
                guard let email = idTextField.text, let password = passwordTextField.text else { return }
                let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
                guard let name = nameTextField.text else { return }
                try await UserManager.shared.createManager(auth: authDataResult, name: name, photoUrl: "")
                if let uploadImage = self.image?.jpegData(compressionQuality: 0.5) {
                    _ = try await StorageManager.shared.saveImage(data: uploadImage, userId: authDataResult.uid)
                }
                self.dismiss(animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
