//
//  SearchTableViewCell.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    
    var userIcon = IconImageView(frame: .zero)
    var userName = CustomLabel(frame: .zero, fontSize: 15.0, text: "", paddingSize: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // コンテントビュー設定
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // サブビュー設定
        contentView.addSubview(userIcon)
        contentView.addSubview(userName)
        // 制約設定
        SearchTableViewConstraints.makeConstraints(contentView: contentView, userIcon: userIcon, userName: userName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
