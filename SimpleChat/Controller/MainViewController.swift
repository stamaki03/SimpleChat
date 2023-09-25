//
//  MainViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

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
                    var image: UIImage? = nil
                    if let url = dbUser.photoUrl {
                        let islandRef = Storage.storage().reference().child(url)
                        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                print(error)
                            } else {
                                image = UIImage(data: data!)
                                self.mainViewCellItems.append(UserItems(chatroomId: chatroomId, uid: dbUser.uid, name: dbUser.name, email: dbUser.email, photo: image, chatroom: dbUser.chatroom, dateCreated: dbUser.dateCreated))
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            } catch {
                print(error)
            }
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

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        if let image = mainViewCellItems[indexPath.row]?.photo {
            cell.userIcon.image = image
        }
        cell.userName.text = mainViewCellItems[indexPath.row]?.name
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController(chatroomId: mainViewCellItems[indexPath.row]?.chatroomId ?? "")
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}
