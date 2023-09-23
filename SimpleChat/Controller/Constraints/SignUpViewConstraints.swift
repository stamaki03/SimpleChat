//
//  SignUpViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

struct SignUpViewConstraints {
    static func makeConstraints(view: UIView, iconImageView: CustomButton, deleteImage: CustomButton, signUpTitleLabel: TitleLabel, idLabel: CustomLabel, idTextField: CustomTextField, nameLabel: CustomLabel, nameTextField: CustomTextField, passwordLabel: CustomLabel, passwordTextField: CustomTextField, repasswordLabel: CustomLabel, repasswordTextField: CustomTextField, signUpButton: SelectButton){
        signUpTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        signUpTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        signUpTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpTitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        iconImageView.topAnchor.constraint(equalTo: signUpTitleLabel.bottomAnchor, constant: 20).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        deleteImage.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20).isActive = true
        deleteImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        deleteImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        deleteImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        idLabel.topAnchor.constraint(equalTo: deleteImage.bottomAnchor, constant: 20).isActive = true
        idLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        idLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        idLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        idTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 0).isActive = true
        idTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        idTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        idTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 0).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        passwordLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0).isActive = true
        passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 0).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        repasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 0).isActive = true
        repasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        repasswordLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        repasswordLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        repasswordTextField.topAnchor.constraint(equalTo: repasswordLabel.bottomAnchor, constant: 0).isActive = true
        repasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        repasswordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        repasswordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        signUpButton.topAnchor.constraint(equalTo: repasswordTextField.bottomAnchor, constant: 50).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
}
