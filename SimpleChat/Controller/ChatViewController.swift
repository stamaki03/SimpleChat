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
    // MARK: - Properties
    private let chatBaseView = ChatBaseView()
    private let chatSendButton = CustomButton(frame: .zero, cornerRadius: 10, systemName: "paperplane")
    private let chatTextField = CustomTextField(frame: .zero, placeholder: "メッセージを入力", paddingSize: 10)
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.plain)
        view.allowsSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: "MyChatCell")
        view.register(OthersChatTableViewCell.self, forCellReuseIdentifier: "OthersChatCell")
        return view
    }()
    
    private let chatroomId: String
    private let otherMemberId: String
    private let otherMemberName: String
    private let otherMemberImage: UIImage
    
    private var chatViewCellItems: [ChatModel] = []
    
    // MARK: - Init
    init(chatroomId: String, otherMemberId: String, otherMemberName: String, otherMemberImage: UIImage) {
        self.chatroomId = chatroomId
        self.otherMemberId = otherMemberId
        self.otherMemberName = otherMemberName
        self.otherMemberImage = otherMemberImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        setBarTitle()
        setButtonAction()
        // チャットメッセージの読み込み
        loadMessages()
    }
    
    private func setView() {
        tableView.backgroundColor = .white
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
    
    private func setBarTitle(){
        let titleLabel = UILabel()
        titleLabel.text = otherMemberName
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }
    
    private func setButtonAction() {
        chatSendButton.addTarget(self, action: #selector(sendMessage(sender:)), for:.touchUpInside)
        chatTextField.addTarget(self, action: #selector(sendMessage(sender:)), for:.editingDidEndOnExit)
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
                        if let userId = data["userId"] as? String, let chatText = data["chatText"] as? String, let updateDate = data["sendTime"] as? Timestamp {
                            let newMessage = ChatModel(userId: userId, userMessage: chatText, updateDate: updateDate.dateValue())
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
    
    // MARK: - Actions
    @objc internal func sendMessage(sender: UIButton) {
        Task {
            do {
                let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
                guard let chatText = chatTextField.text else {return}
                self.chatTextField.text = ""
                UserManager.shared.updatelatesteMessageInfo(userId1: currentUser.uid, userId2: otherMemberId, chatroomId: self.chatroomId, chatText: chatText)
                try await ChatroomManager.shared.addDocument(chatroomId: self.chatroomId, userId: currentUser.uid, chatText: chatText)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Extensions
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatViewCellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chatViewCellItems[indexPath.row].userId == Auth.auth().currentUser?.uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell", for: indexPath) as! MyChatTableViewCell
            cell.userMessage.text = chatViewCellItems[indexPath.row].userMessage
            let date = self.chatViewCellItems[indexPath.row].updateDate
            let df = makeDateFormatter()
            cell.sendTime.text = df.string(from: date)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OthersChatCell", for: indexPath) as! OthersChatTableViewCell
            cell.userIcon.image = otherMemberImage
            cell.userMessage.text = chatViewCellItems[indexPath.row].userMessage
            let date = self.chatViewCellItems[indexPath.row].updateDate
            let df = makeDateFormatter()
            cell.sendTime.text = df.string(from: date)
            return cell
        }
    }
    
    private func makeDateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        df.dateFormat = "yy/MM/dd HH:mm"
        return df
    }
}
