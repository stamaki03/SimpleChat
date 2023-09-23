//
//  MainViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit
import FirebaseAuth

final class MainViewController: UIViewController {
    
    let user = Auth.auth().currentUser
    
    private let mainViewCellItems: [UserItems] = [
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
        // バーボタンアクション設定
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearchViewController))
        let settingButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(goToSettingViewController))
        navigationItem.rightBarButtonItems = [searchButton, settingButton]
    }
    
    @objc internal func goToSearchViewController() {
        let searchViewController = SearchViewController()
        self.navigationController?.present(searchViewController, animated: true)
    }
    
    @objc internal func goToSettingViewController() {
        let settingViewController = SettingViewController()
        self.navigationController?.present(settingViewController, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        // cell.userName.text = mainViewCellItems[indexPath.row].userName
        cell.userName.text = user?.displayName ?? ""
        cell.userLastMessage.text = mainViewCellItems[indexPath.row].userLastMessage
        cell.userLastMessageTime.text = mainViewCellItems[indexPath.row].userLastMessageTime
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController()
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}
