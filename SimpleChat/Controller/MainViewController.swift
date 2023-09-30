//
//  MainViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class MainViewController: UIViewController {
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MainTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    private var mainViewCellItems: [UserModel?] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        setBarItem()
        // チャットルームの読み込み
        Task {
            let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
            loadChatroom(user: currentUser.uid)
        }
    }
    
    private func loadChatroom(user: String) {
        Firestore.firestore().collection("users").document(user).collection("chatroom").order(by: "updateDate", descending: true).addSnapshotListener { [weak self] (querrySnapshot, error) in
            if let error = error {
                print(error)
            } else {
                Task {
                    guard let snapshotDocments = querrySnapshot?.documents else {return }
                    self?.mainViewCellItems = []
                    for doc in snapshotDocments {
                        let data = doc.data()
                        guard let chatroomId = data["chatroomId"] as? String, let lastMessage = data["lastMessage"] as? String, let updateDate = data["updateDate"] as? Timestamp, let otherUserId = data["otherUserId"] as? String else { return }
                        let otherUser = try await UserManager.shared.fetchUser(userId: otherUserId)
                        self?.mainViewCellItems.append(UserModel(chatroomId: chatroomId, uid: otherUser.uid, name: otherUser.name, photoUrl: otherUser.photoUrl, lastMessage: lastMessage, updateDate: updateDate.dateValue()))
                    }
                }
            }
        }
    }
    
    private func setView() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.frame = self.view.frame
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isMultipleTouchEnabled = false
        view.addSubview(tableView)
    }
    
    private func setBarItem() {
        navigationItem.hidesBackButton = true
        let logoutButton = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItems = [logoutButton]
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(goToProfileViewController))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearchViewController))
        let settingButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(goToSettingViewController))
        navigationItem.rightBarButtonItems = [searchButton, settingButton, profileButton]
    }
    
    @objc internal func logout() {
        do {
            try AuthenticationManager.shared.signOutUser()
            self.navigationController?.popViewController(animated: false)
        } catch {
            print(error)
        }
    }
    
    @objc internal func goToProfileViewController() {
        let settingViewController = ProfileViewController()
        self.navigationController?.pushViewController(settingViewController, animated: false)
    }
    
    @objc internal func goToSearchViewController() {
        var chatMemberArray: [String?] = []
        for chatMember in mainViewCellItems {
            chatMemberArray.append(chatMember?.uid)
        }
        let searchViewController = SearchViewController(userId: chatMemberArray)
        searchViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(searchViewController, animated: false)
    }
    
    @objc internal func goToSettingViewController() {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: false)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        cell.userName.text = self.mainViewCellItems[indexPath.row]?.name
        cell.userLastMessage.text = self.mainViewCellItems[indexPath.row]?.lastMessage
        cell.userIcon.image = UIImage(systemName: "person.circle")
        if let date = self.mainViewCellItems[indexPath.row]?.updateDate {
            let df = makeDateFormatter()
            cell.userLastMessageTime.text = df.string(from: date)
        }
        if let url = mainViewCellItems[indexPath.row]?.photoUrl {
            if !url.isEmpty {
                Task {
                    let imageData = try await fetchImage(url: url)
                    cell.userIcon.image = UIImage(data: imageData)!
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = mainViewCellItems[indexPath.row]?.photoUrl {
            if url.isEmpty {
                let chatViewController = ChatViewController(chatroomId: mainViewCellItems[indexPath.row]?.chatroomId ?? "", otherMemberId: mainViewCellItems[indexPath.row]?.uid ?? "", otherMemberName: mainViewCellItems[indexPath.row]?.name ?? "", otherMemberImage: UIImage(systemName: "person.circle")!)
                self.navigationController?.pushViewController(chatViewController, animated: true)
            } else {
                Task {
                    let imageData = try await fetchImage(url: url)
                    let chatViewController = ChatViewController(chatroomId: mainViewCellItems[indexPath.row]?.chatroomId ?? "", otherMemberId: mainViewCellItems[indexPath.row]?.uid ?? "", otherMemberName: mainViewCellItems[indexPath.row]?.name ?? "", otherMemberImage: UIImage(data: imageData) ?? UIImage(systemName: "person.circle")!)
                    self.navigationController?.pushViewController(chatViewController, animated: true)
                }
            }
        }
    }
    
    private func makeDateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }
    
    private func fetchImage(url: String) async throws -> Data {
        let imageUrl = URL(string: url)!
        let (imageData, urlResponse) = try await URLSession.shared.data(from: imageUrl)
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard 200 ..< 300 ~= urlResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return imageData
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let normalAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
            Task {
                guard let currentUser = AuthenticationManager.shared.getcurrentUser(), let chatroomId = self.mainViewCellItems[indexPath.row]?.chatroomId, let otherUser = self.mainViewCellItems[indexPath.row]?.uid else { return }
                try await ChatroomManager.shared.deleteChatroom(chatroomId: chatroomId)
                try await UserManager.shared.deleteChatroom(user: currentUser.uid, chatroomId: chatroomId)
                try await UserManager.shared.deleteChatroom(user: otherUser, chatroomId: chatroomId)
            }
          }
          let configuration = UISwipeActionsConfiguration(actions: [normalAction])
          return configuration
      }
}
