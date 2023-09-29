//
//  SearchViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class SearchViewController: UIViewController {
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    private var otherMember: String?
    private var currentUser: AuthenticationModel?
    private var userIdArray: [String?]
    private var serchViewCellItems: [FSUserModel] = []
    
    init(userId: [String?]) {
        self.userIdArray = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        setBarItem()
        // ユーザ情報取得
        Task {
            self.currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
            try await fetchAllUserData(currentUser: currentUser)
            self.tableView.reloadData()
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
        let backButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(backView))
        navigationItem.leftBarButtonItems = [backButton]
        let registerButton = UIBarButtonItem(title: "登録", style: .plain, target: self, action: #selector(registerMember))
        navigationItem.rightBarButtonItems = [registerButton]
    }
    
    private func fetchAllUserData(currentUser: AuthenticationModel?) async throws {
        guard let currentUser = currentUser else {return}
        let allUserArray = try await UserManager.shared.fetchAllUser()
        for allUser in allUserArray {
            if allUser.uid != currentUser.uid && !userIdArray.contains(allUser.uid) {
                self.serchViewCellItems.append(allUser)
            }
        }
    }
    
    @objc internal func backView() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc internal func registerMember() {
        guard let otherMember = otherMember else { return }
        Task {
            do {
                self.tableView.isUserInteractionEnabled = false
                let chatroomId = UUID().uuidString
                guard let member1 = currentUser?.uid else {return}
                let member2 = otherMember
                let members = [member1, member2]
                try await ChatroomManager.shared.createChatroom(chatroomId: chatroomId, members: members)
                try await UserManager.shared.adUserTodChatroom(chatroomId: chatroomId, user: member1, otherUserId: member2)
                try await UserManager.shared.adUserTodChatroom(chatroomId: chatroomId, user: member2, otherUserId: member1)
                UserManager.shared.updatelatesteMessageInfo(userId1: member1, userId2: member2, chatroomId: chatroomId, chatText: "新規メッセージ")
                self.navigationController?.popViewController(animated: false)
            } catch {
                print(error)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serchViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.userName.text = serchViewCellItems[indexPath.row].name
        cell.userIcon.image = UIImage(systemName: "person.circle")
        if let url = serchViewCellItems[indexPath.row].photoUrl {
            if !url.isEmpty {
                Task {
                    let imageData = try await fetchImage(url: url)
                    cell.userIcon.image = UIImage(data: imageData)!
                }
            }
        }
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.otherMember = serchViewCellItems[indexPath.row].uid
    }
}
