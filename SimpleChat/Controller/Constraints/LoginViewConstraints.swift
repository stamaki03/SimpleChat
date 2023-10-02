//
//  LoginViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

struct LoginViewConstraints {
    static func makeConstraints(view: UIView, appTitleLabel: CustomLabel, idLabel: CustomLabel, idTextField: CustomTextField, passwordLabel: CustomLabel, passwordTextField: CustomTextField, loginSelectButton: CustomSelectButton, signUpButton: CustomSelectButton, resetPasswordButton: CustomSelectButton){
        appTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        appTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        appTitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        idLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 30).isActive = true
        idLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        idLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        idLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        idTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 0).isActive = true
        idTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        idTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        idTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        passwordLabel.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 30).isActive = true
        passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 0).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        loginSelectButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50).isActive = true
        loginSelectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        loginSelectButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginSelectButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        signUpButton.topAnchor.constraint(equalTo: loginSelectButton.bottomAnchor, constant: 30).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        resetPasswordButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 30).isActive = true
        resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        resetPasswordButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        resetPasswordButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
