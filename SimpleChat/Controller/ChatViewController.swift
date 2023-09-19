//
//  ChatViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

final class ChatViewController: UIViewController {
    
    private let chatViewCellItems: [UserMessages] = [
        UserMessages(userName: "user1", userMessage: "はじめまして。"),
        UserMessages(userName: "useruser2", userMessage: "おはよう。"),
        UserMessages(userName: "user1", userMessage: "こんにちは。"),
        UserMessages(userName: "useruser4", userMessage: "こんばんは。"),
        UserMessages(userName: "useruser4", userMessage: "よろしくねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねね。"),
        UserMessages(userName: "user1", userMessage: "よろしくねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねねね。")
    ]
    
    let chatBaseView = ChatBaseView()
    let chatSendButton = CustomButton(frame: .zero, cornerRadius: 10, systemName: "paperplane")
    let chatTextField = CustomTextField(frame: .zero, placeholder: "メッセージを入力")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // ビュー設定
        view.backgroundColor = .white
        // テーブルビュー設定
        let tableView = UITableView(frame: self.view.frame, style: UITableView.Style.plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyChatTableViewCell.self, forCellReuseIdentifier: "MyChatCell")
        tableView.register(OthersChatTableViewCell.self, forCellReuseIdentifier: "OthersChatCell")
        view.addSubview(tableView)
        // サブビュー設定
        view.addSubview(chatBaseView)
        chatBaseView.addSubview(chatSendButton)
        chatBaseView.addSubview(chatTextField)
        // 制約設定
        ChatViewConstraints.makeConstraints(view: view, chatBaseView: chatBaseView, chatTextField: chatTextField, chatSendButton: chatSendButton)
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chatViewCellItems[indexPath.row].userName == "user1"{
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
