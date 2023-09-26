//
//  MainViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit

final class MainViewController: UIViewController {
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MainTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    private var mainViewCellItems: [UserModel?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        // バーボタンアクション設定
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearchViewController))
        let settingButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(goToSettingViewController))
        navigationItem.rightBarButtonItems = [searchButton, settingButton]
        // ユーザ情報取得
        Task {
            try await fetchUsersData()
            self.tableView.reloadData()
        }
    }
    
    private func setView() {
        // ビュー設定
        view.backgroundColor = .white
        // テーブルビュー設定
        tableView.frame = self.view.frame
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isMultipleTouchEnabled = false
        view.addSubview(tableView)
    }
    
    private func fetchUsersData() async throws {
        do {
            self.mainViewCellItems = []
            let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
            let userInfo = try await UserManager.shared.fetchUser(userId: currentUser.uid)
            let chatroomIdArray = userInfo.chatroom.filter{ $0 != nil }.map{ $0! }
            for chatroomId in chatroomIdArray {
                let otherUserId = try await UserManager.shared.fetchOtherMember(chatroomId: chatroomId)
                let otherUser = try await UserManager.shared.fetchUser(userId: otherUserId)
                self.mainViewCellItems.append(UserModel(chatroomId: chatroomId, uid: otherUser.uid, name: otherUser.name, email: otherUser.email, photoUrl: otherUser.photoUrl, chatroom: otherUser.chatroom, dateCreated: otherUser.dateCreated))
            }
        } catch {
            print(error)
        }
    }
    
    @objc internal func goToSearchViewController() {
        var zzz = [String?]()
        for aaa in mainViewCellItems {
            zzz.append(aaa?.uid)
        }
        let searchViewController = SearchViewController(userId: zzz)
        self.navigationController?.present(searchViewController, animated: true)
    }
    
    @objc internal func goToSettingViewController() {
        let settingViewController = SettingViewController()
        self.navigationController?.present(settingViewController, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        if let url = mainViewCellItems[indexPath.row]?.photoUrl {
            if !url.isEmpty {
                Task {
                    let imageUrl = URL(string: url)!
                    let (imageData, _) = try await URLSession.shared.data(from: imageUrl)
                    cell.userIcon.image = UIImage(data: imageData)!
                    cell.userName.text = self.mainViewCellItems[indexPath.row]?.name
                    return cell
                }
            }
        }
        cell.userName.text = mainViewCellItems[indexPath.row]?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController(chatroomId: mainViewCellItems[indexPath.row]?.chatroomId ?? "")
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}
