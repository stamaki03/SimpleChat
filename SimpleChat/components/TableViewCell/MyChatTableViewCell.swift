//
//  MyChatTableViewCell.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class MyChatTableViewCell: UITableViewCell {
    
    let chatBaseView = ChatBaseView()
    var userMessage = CustomChatLabel(frame: .zero, fontSize: 15.0, text: "")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // コンテントビュー設定
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // サブビュー設定
        userMessage.layer.borderColor = UIColor.blue.cgColor
        userMessage.layer.borderWidth = 1
        userMessage.layer.cornerRadius = 5
        
        contentView.addSubview(userMessage)
        // 制約設定
        MyChatTableViewConstraints.makeConstraints(contentView: contentView, userMessage: userMessage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
