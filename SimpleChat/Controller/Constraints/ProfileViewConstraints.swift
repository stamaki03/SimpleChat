//
//  ProfileViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/29.
//

import UIKit

struct ProfileViewConstraints {
    static func makeConstraints(view: UIView, iconImageView: IconImageView, signUpTitleLabel: TitleLabel, idLabel: CustomLabel, idText: CustomLabel, nameLabel: CustomLabel, nameText: CustomLabel, backButton: SelectButton){
        signUpTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        signUpTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        signUpTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpTitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        iconImageView.topAnchor.constraint(equalTo: signUpTitleLabel.bottomAnchor, constant: 25).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        idLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 50).isActive = true
        idLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        idLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        idLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        idText.leftAnchor.constraint(equalTo: idLabel.rightAnchor, constant: 0).isActive = true
        idText.centerYAnchor.constraint(equalTo: idLabel.centerYAnchor, constant: 0).isActive = true
        idText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        idText.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 0).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        nameText.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 0).isActive = true
        nameText.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor, constant: 0).isActive = true
        nameText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameText.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        backButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
}
