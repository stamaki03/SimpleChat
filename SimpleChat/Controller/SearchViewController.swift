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
        // ユーザ情報取得
        Task {
            self.currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
            try await fetchAllUserData(currentUser: currentUser)
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
        view.addSubview(tableView)
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
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serchViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.userName.text = serchViewCellItems[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            do {
                self.tableView.isUserInteractionEnabled = false
                let chatroomId = UUID().uuidString
                guard let member1 = currentUser?.uid else {return}
                let member2 = serchViewCellItems[indexPath.row].uid
                let members = [member1, member2]
                try await ChatroomManager.shared.createChatroom(chatroomId: chatroomId, members: members)
                try await UserManager.shared.adUserTodChatroom(chatroomId: chatroomId, user: member1)
                try await UserManager.shared.adUserTodChatroom(chatroomId: chatroomId, user: member2)
                self.dismiss(animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
    }
}
