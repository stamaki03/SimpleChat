//
//  SearchViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let serchViewCellItems: [UserItems] = [
        UserItems(userIcon: IconImageView(frame: .zero), userName: "useruser1", userPassword: "12345", userLastMessage: "はじめまして。", userLastMessageTime: "2022/12/09", badgeIcon: BadgeImageView(frame: .zero)),
        UserItems(userIcon: IconImageView(frame: .zero), userName: "useruser2", userPassword: "12345", userLastMessage: "おはよう。", userLastMessageTime: "2022/12/09", badgeIcon: BadgeImageView(frame: .zero)),
        UserItems(userIcon: IconImageView(frame: .zero), userName: "user3", userPassword: "12345", userLastMessage: "こんにちは。", userLastMessageTime: "2022/12/09", badgeIcon: BadgeImageView(frame: .zero)),
        UserItems(userIcon: IconImageView(frame: .zero), userName: "user4", userPassword: "12345", userLastMessage: "こんばんは。", userLastMessageTime: "2022/12/09", badgeIcon: BadgeImageView(frame: .zero))
    ]
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MainTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // ビュー設定
        view.backgroundColor = .white
        // テーブルビュー設定
        tableView.frame = self.view.frame
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serchViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.userName.text = serchViewCellItems[indexPath.row].userName
        return cell
    }
}
