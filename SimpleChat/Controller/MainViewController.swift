//
//  MainViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var mainViewCellItems: [UserItems?] = []
    
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
        // ユーザ情報取得
        Task {
            do {
                let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
                let userInfo = try await UserManager.shared.getUser(userId: currentUser.uid)
                let chatroomIdArray = userInfo.chatroom.filter{ $0 != nil }.map{ $0! }
                for chatroomId in chatroomIdArray {
                    let otherUserId = try await UserManager.shared.getOthereMember(chatroomId: chatroomId)
                    let dbUser = try await UserManager.shared.getUser(userId: otherUserId)
                    mainViewCellItems.append(UserItems(chatroomId: chatroomId, uid: dbUser.uid, name: dbUser.name, email: dbUser.email, photoUrl: dbUser.photoUrl, chatroom: dbUser.chatroom, dateCreated: dbUser.dateCreated))
                }
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
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
        cell.userName.text = mainViewCellItems[indexPath.row]?.uid
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController(chatroomId: mainViewCellItems[indexPath.row]?.chatroomId ?? "")
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}
