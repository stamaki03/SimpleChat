//
//  MainTableViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct MainTableViewConstraints {
    static func makeConstraints(contentView: UIView, userIcon: IconImageView, userName: CustomLabel, userLastMessage: CustomLabel, userLastMessageTime: CustomLabel, badgeIcon: BadgeImageView){
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        userIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        userIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        userIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userName.rightAnchor.constraint(lessThanOrEqualTo: userLastMessageTime.leftAnchor, constant: -10).isActive = true
        userName.bottomAnchor.constraint(equalTo: userLastMessage.topAnchor, constant: -10).isActive = true
        userName.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 10).isActive = true
        
        userLastMessage.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10).isActive = true
        userLastMessage.rightAnchor.constraint(equalTo: badgeIcon.leftAnchor, constant: -10).isActive = true
        userLastMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        userLastMessage.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 10).isActive = true
        
        userLastMessageTime.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userLastMessageTime.rightAnchor.constraint(equalTo: badgeIcon.leftAnchor, constant: -10).isActive = true
        userLastMessageTime.bottomAnchor.constraint(equalTo: userLastMessage.topAnchor, constant: -10).isActive = true
        userLastMessageTime.leftAnchor.constraint(greaterThanOrEqualTo: userName.rightAnchor, constant: 10).isActive = true
        
        badgeIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        badgeIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        badgeIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        badgeIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
