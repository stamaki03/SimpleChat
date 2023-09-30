//
//  SearchTableViewConstraints.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct SearchTableViewConstraints {
    static func makeConstraints(contentView: UIView, userIcon: CustomImageView, userName: CustomLabel){
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        userIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        userIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        userIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userName.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 10).isActive = true
        userName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
