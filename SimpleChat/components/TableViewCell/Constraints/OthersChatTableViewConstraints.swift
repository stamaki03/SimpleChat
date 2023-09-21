//
//  OthersChatTableViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct OthersChatTableViewConstraints {
    static func makeConstraints(contentView: UIView, userIcon: IconImageView, userMessage: CustomChatLabel){
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        userIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userIcon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10).isActive = true
        userIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        userIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        userMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userMessage.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -80).isActive = true
        userMessage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10).isActive = true
        userMessage.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 10).isActive = true
    }
}
