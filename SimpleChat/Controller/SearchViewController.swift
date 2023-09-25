//
//  SearchViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

class SearchViewController: UIViewController {
    
    var userIdArray: [String?]
    
    private var currentUser: AuthDataResultModel?
    private var serchViewCellItems: [DBuser] = []
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
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
        // ビュー設定
        view.backgroundColor = .white
        // テーブルビュー設定
        tableView.frame = self.view.frame
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // ユーザ情報取得
        Task {
            self.currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
            guard let currentUser = currentUser else {return}
            let dbUserArray = try await UserManager.shared.getAllUser()
            for dbUser in dbUserArray {
                if dbUser.uid != currentUser.uid && !userIdArray.contains(dbUser.uid) {
                    self.serchViewCellItems.append(dbUser)
                }
            }
            self.tableView.reloadData()
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
                let chatroomId = UUID().uuidString
                guard let member1 = currentUser?.uid else {return}
                let member2 = serchViewCellItems[indexPath.row].uid
                let members = [member1, member2]
                try await ChatroomManager.shared.createChatroom(chatroomId: chatroomId, members: members)
                try await UserManager.shared.addChatroom(chatroomId: chatroomId, user: member1)
                try await UserManager.shared.addChatroom(chatroomId: chatroomId, user: member2)
                self.dismiss(animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
    }
}
