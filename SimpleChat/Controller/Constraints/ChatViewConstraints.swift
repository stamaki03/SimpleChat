//
//  ChatViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct ChatViewConstraints {
    static func makeConstraints(view: UIView, chatBaseView: UIView, chatTextField: UITextField, chatSendButton: UIButton) {
        chatBaseView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        chatBaseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        chatBaseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        chatBaseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        chatTextField.centerYAnchor.constraint(equalTo: chatSendButton.centerYAnchor, constant: 0).isActive = true
        chatTextField.rightAnchor.constraint(equalTo: chatSendButton.leftAnchor, constant: -5).isActive = true
        chatTextField.bottomAnchor.constraint(equalTo: chatBaseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        chatTextField.leftAnchor.constraint(equalTo: chatBaseView.leftAnchor, constant: 10).isActive = true
        
        chatSendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        chatSendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chatSendButton.rightAnchor.constraint(equalTo: chatBaseView.rightAnchor, constant: -10).isActive = true
        chatSendButton.bottomAnchor.constraint(equalTo: chatBaseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}
