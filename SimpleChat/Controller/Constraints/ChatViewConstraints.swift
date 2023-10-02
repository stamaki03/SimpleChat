//
//  ChatViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct ChatViewConstraints {
    static func makeConstraints(view: UIView, chatBaseView: UIView, chatTextField: CustomTextField, chatSendButton: CustomButton) {
        chatBaseView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        chatBaseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        chatBaseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        chatBaseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

        chatTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chatTextField.topAnchor.constraint(equalTo: chatBaseView.topAnchor, constant: 20).isActive = true
        chatTextField.rightAnchor.constraint(equalTo: chatSendButton.leftAnchor, constant: -10).isActive = true
        chatTextField.leftAnchor.constraint(equalTo: chatBaseView.leftAnchor, constant: 20).isActive = true
        
        chatSendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        chatSendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chatSendButton.rightAnchor.constraint(equalTo: chatBaseView.rightAnchor, constant: -20).isActive = true
        chatSendButton.centerYAnchor.constraint(equalTo: chatTextField.centerYAnchor, constant: 0).isActive = true
    }
}
