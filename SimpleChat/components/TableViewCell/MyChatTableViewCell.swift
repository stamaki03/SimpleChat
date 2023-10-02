//
//  MyChatTableViewCell.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class MyChatTableViewCell: UITableViewCell {
    var userMessage = CustomLabel(frame: .zero, fontSize: 20.0, text: "", textAlignment: .left, paddingSize: 10)
    var sendTime = CustomLabel(frame: .zero, fontSize: 15.0, text: "aaa", textAlignment: .left, paddingSize: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // コンテントビュー設定
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // サブビュー設定
        userMessage.layer.backgroundColor = (UIColor(named: "bg") ?? .white).cgColor
        userMessage.layer.borderColor = (UIColor(named: "bg") ?? .white).cgColor
        userMessage.layer.borderWidth = 1
        userMessage.layer.cornerRadius = 5
        userMessage.textColor = .white
        sendTime.textAlignment = NSTextAlignment.right
        contentView.addSubview(sendTime)
        contentView.addSubview(userMessage)
        // 制約設定
        MyChatTableViewConstraints.makeConstraints(contentView: contentView, sendTime: sendTime, userMessage: userMessage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
