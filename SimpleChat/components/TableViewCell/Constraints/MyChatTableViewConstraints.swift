//
//  MyChatTableViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct MyChatTableViewConstraints {
    static func makeConstraints(contentView: UIView, sendTime: CustomLabel, userMessage: CustomLabel){
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        sendTime.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendTime.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        sendTime.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor, constant: 10).isActive = true
        
        userMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userMessage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        userMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        userMessage.leftAnchor.constraint(equalTo: sendTime.rightAnchor, constant: 10).isActive = true
    }
}
