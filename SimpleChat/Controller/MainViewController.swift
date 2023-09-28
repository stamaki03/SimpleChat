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
            try await setBarTitle(currentUser: currentUser)
        }
    }
    
    private func loadChatroom(user: String) {
        Firestore.firestore().collection("users").document(user).collection("chatroom").order(by: "updateDate", descending: true).addSnapshotListener { [weak self] (querrySnapshot, error) in
            if let error = error {
                print(error)
            } else {
                guard let snapshotDocments = querrySnapshot?.documents else {return }
                self?.mainViewCellItems = []
                for doc in snapshotDocments {
                    let data = doc.data()
                    guard let chatroomId = data["chatroomId"] as? String, let lastMessage = data["lastMessage"] as? String, let updateDate = data["updateDate"] as? Timestamp else { return }
                    Task {
                        let otherUserId = try await UserManager.shared.fetchOtherMember(chatroomId: chatroomId)
                        let otherUser = try await UserManager.shared.fetchUser(userId: otherUserId)
                        self?.mainViewCellItems.append(UserModel(chatroomId: chatroomId, uid: otherUser.uid, name: otherUser.name, photoUrl: otherUser.photoUrl, lastMessage: lastMessage, updateDate: updateDate.dateValue()))
                    }
                }
            }
        }
    }
    
    private func setView() {
        view.backgroundColor = .white
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
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearchViewController))
        let settingButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(goToSettingViewController))
        navigationItem.rightBarButtonItems = [searchButton, settingButton]
    }
    
    private func setBarTitle(currentUser: AuthenticationModel) async throws {
        let titleLabel = UILabel()
        let currentUserData = try await UserManager.shared.fetchUser(userId: currentUser.uid)
        titleLabel.text = currentUserData.name
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }
    
    @objc internal func logout() {
        do {
            try AuthenticationManager.shared.signOutUser()
            self.navigationController?.popViewController(animated: false)
        } catch {
            print(error)
        }
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
        if let date = self.mainViewCellItems[indexPath.row]?.updateDate {
            let df = DateFormatter()
            df.calendar = Calendar(identifier: .gregorian)
            df.locale = Locale(identifier: "ja_JP")
            df.timeZone = TimeZone(identifier: "Asia/Tokyo")
            df.dateStyle = .short
            df.timeStyle = .short
            cell.userLastMessageTime.text = df.string(from: date)
        }
        if let url = mainViewCellItems[indexPath.row]?.photoUrl {
            if !url.isEmpty {
                Task {
                    let imageUrl = URL(string: url)!
                    let (imageData, urlResponse) = try await URLSession.shared.data(from: imageUrl)
                    guard let urlResponse = urlResponse as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    guard 200 ..< 300 ~= urlResponse.statusCode else {
                        throw URLError(.badServerResponse)
                    }
                    cell.userIcon.image = UIImage(data: imageData)!
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController(chatroomId: mainViewCellItems[indexPath.row]?.chatroomId ?? "", otherMemberId: mainViewCellItems[indexPath.row]?.uid ?? "")
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}
