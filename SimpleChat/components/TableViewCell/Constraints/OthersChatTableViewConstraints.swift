//
//  OthersChatTableViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct OthersChatTableViewConstraints {
    static func makeConstraints(contentView: UIView, userIcon: CustomImageView, userMessage: CustomLabel, sendTime: CustomLabel){
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        userIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        userIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        userMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userMessage.rightAnchor.constraint(equalTo: sendTime.leftAnchor, constant: -10).isActive = true
        userMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        userMessage.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 10).isActive = true
        
        sendTime.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendTime.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendTime.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -10).isActive = true
        sendTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
