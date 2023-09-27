//
//  ChatViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class ChatViewController: UIViewController, UITextFieldDelegate {
    let chatBaseView = ChatBaseView()
    let chatSendButton = CustomButton(frame: .zero, cornerRadius: 10, systemName: "paperplane")
    let chatTextField = CustomTextField(frame: .zero, placeholder: "メッセージを入力", paddingSize: 10)
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.plain)
        view.allowsSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: "MyChatCell")
        view.register(OthersChatTableViewCell.self, forCellReuseIdentifier: "OthersChatCell")
        return view
    }()
    
    private var chatroomId: String
    private var chatViewCellItems: [ChatModel] = []
    
    init(chatroomId: String) {
        self.chatroomId = chatroomId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        setButtonAction()
        // チャットメッセージの読み込み
        loadMessages()
    }
    
    private func setView() {
        view.backgroundColor = .white
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 120)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        chatTextField.delegate = self
        view.addSubview(chatBaseView)
        chatBaseView.addSubview(chatSendButton)
        chatBaseView.addSubview(chatTextField)
        // 制約設定
        ChatViewConstraints.makeConstraints(view: view, chatBaseView: chatBaseView, chatTextField: chatTextField, chatSendButton: chatSendButton)
    }
    
    private func setButtonAction() {
        chatSendButton.addTarget(self, action: #selector(sendMessage(sender:)), for:.touchUpInside)
    }
    
    private func loadMessages() {
        Firestore.firestore().collection("chatroom").document(chatroomId).collection("chats").order(by: "sendTime").addSnapshotListener { [weak self] (querrySnapshot, error) in
            if let e = error {
                print(e)
            } else {
                self?.chatViewCellItems = []
                if let snapshotDocments = querrySnapshot?.documents {
                    for doc in snapshotDocments {
                        let data = doc.data()
                        if let userName = data["userName"] as? String, let chatText = data["chatText"] as? String {
                            let newMessage = ChatModel(userName: userName, userMessage: chatText)
                            print(newMessage)
                            self?.chatViewCellItems.append(newMessage)
                            Task.detached { @MainActor in
                                self?.tableView.reloadData()
                                let indexPath = IndexPath(row: (self?.chatViewCellItems.count ?? 1) - 1, section: 0)
                                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc internal func sendMessage(sender: UIButton) {
        Task {
            do {
                let userName = try AuthenticationManager.shared.getAuthenticatedUser()
                guard let userEmail = userName.email, let chatText = chatTextField.text else {return}
                try await ChatroomManager.shared.addDocument(chatroomId: self.chatroomId, userEmail: userEmail, chatText: chatText)
                self.chatTextField.text = ""
            } catch {
                print(error)
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
