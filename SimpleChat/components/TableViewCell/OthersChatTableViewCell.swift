//
//  OthersChatTableViewCell.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class OthersChatTableViewCell: UITableViewCell {
    var userIcon = CustomImageView(frame: .zero, cornerRadius: 25)
    var userMessage = CustomLabel(frame: .zero, fontSize: 20.0, text: "", paddingSize: 10)
    var sendTime = CustomLabel(frame: .zero, fontSize: 15.0, text: "aaa", paddingSize: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // コンテントビュー設定
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // サブビュー設定
        userMessage.layer.borderColor = (UIColor(named: "bg") ?? .white).cgColor
        userMessage.layer.borderWidth = 1
        userMessage.layer.cornerRadius = 5
        userMessage.textColor = .black
        sendTime.textAlignment = NSTextAlignment.left
        contentView.addSubview(userIcon)
        contentView.addSubview(userMessage)
        contentView.addSubview(sendTime)
        // 制約設定
        OthersChatTableViewConstraints.makeConstraints(contentView: contentView, userIcon: userIcon, userMessage: userMessage, sendTime: sendTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
