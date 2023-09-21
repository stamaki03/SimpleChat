//
//  MyChatTableViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct MyChatTableViewConstraints {
    static func makeConstraints(contentView: UIView, userMessage: CustomChatLabel){
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        userMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userMessage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        userMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        userMessage.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor, constant: 80).isActive = true
    }
}
