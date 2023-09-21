//
//  ChatViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


final class ChatViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    private var chatViewCellItems: [UserMessages] = []
    
    let chatBaseView = ChatBaseView()
    let chatSendButton = CustomButton(frame: .zero, cornerRadius: 10, systemName: "paperplane")
    let chatTextField = CustomTextField(frame: .zero, placeholder: "メッセージを入力")
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: "MyChatCell")
        view.register(OthersChatTableViewCell.self, forCellReuseIdentifier: "OthersChatCell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // ビュー設定
        view.backgroundColor = .white
        // テーブルビュー設定
        tableView.frame = self.view.frame
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // サブビュー設定
        view.addSubview(chatBaseView)
        chatBaseView.addSubview(chatSendButton)
        chatBaseView.addSubview(chatTextField)
        // 制約設定
        ChatViewConstraints.makeConstraints(view: view, chatBaseView: chatBaseView, chatTextField: chatTextField, chatSendButton: chatSendButton)
        // ボタンアクション設定
        chatSendButton.addTarget(self, action: #selector(sendMessage(sender:)), for:.touchUpInside)
        // テキストの読み込み
        loadMessages()
    }
    
    private func loadMessages() {
        db.collection("messages").order(by: "sendTime").addSnapshotListener { [weak self] (querrySnapshot, error) in
            if let e = error {
                print(e)
            } else {
                self?.chatViewCellItems = []
                if let snapshotDocments = querrySnapshot?.documents {
                    for doc in snapshotDocments {
                        let data = doc.data()
                        if let userName = data["userName"] as? String, let chatText = data["chatText"] as? String {
                            let newMessage = UserMessages(userName: userName, userMessage: chatText)
                            print(newMessage)
                            self?.chatViewCellItems.append(newMessage)
                            Task.detached { @MainActor in
                                self?.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc internal func sendMessage(sender: UIButton){
        if let userName = Auth.auth().currentUser?.email, let chatText = chatTextField.text {
            db.collection("messages").addDocument(data: ["userName" : userName, "chatText" : chatText, "sendTime" : Date().timeIntervalSince1970]) { error in
                if let e = error {
                    print(e)
                } else {
                    print("success")
                }
            }
        }
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chatViewCellItems[indexPath.row].userName == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell", for: indexPath) as! MyChatTableViewCell
            cell.userMessage.text = chatViewCellItems[indexPath.row].userMessage
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OthersChatCell", for: indexPath) as! OthersChatTableViewCell
            cell.userMessage.text = chatViewCellItems[indexPath.row].userMessage
            return cell
        }
    }
}

//    private var chatViewCellItems: [UserMessages] = [
//        UserMessages(userName: "user1", userMessage: "はじめまして。"),
//        UserMessages(userName: "useruser2", userMessage: "おはよう。"),
//        UserMessages(userName: "user1", userMessage: "こんにちは。"),
//        UserMessages(userName: "useruser4", userMessage: "こんばんは。"),
//        UserMessages(userName: "useruser4", userMessage: "よろしくねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねね。"),
//        UserMessages(userName: "user1", userMessage: "よろしくねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねね。")
//    ]
