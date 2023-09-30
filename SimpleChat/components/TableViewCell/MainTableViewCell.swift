//
//  MainTableViewCell.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    var userIcon = IconImageView(frame: .zero, cornerRadius: 25)
    var userName = CustomLabel(frame: .zero, fontSize: 15.0, text: "", paddingSize: 0)
    var userLastMessage = CustomLabel(frame: .zero, fontSize: 15.0, text: "", paddingSize: 0)
    var userLastMessageTime = CustomLabel(frame: .zero, fontSize: 15.0, text: "", paddingSize: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // コンテントビュー設定
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // サブビュー設定
        contentView.addSubview(userIcon)
        contentView.addSubview(userName)
        contentView.addSubview(userLastMessage)
        contentView.addSubview(userLastMessageTime)
        // 制約設定
        MainTableViewConstraints.makeConstraints(contentView: contentView, userIcon: userIcon, userName: userName, userLastMessage: userLastMessage, userLastMessageTime: userLastMessageTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
