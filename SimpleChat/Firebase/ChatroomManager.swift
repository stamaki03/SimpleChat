//
//  ChatroomManager.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ChatroomManager {
    
    static let shared = ChatroomManager()
   
    private init() {}
    
    func createChatroom(chatroomId: String, members: [String]) async throws {
        let userData: [String:Any] = [
            "chatroomId": chatroomId,
            "members": members,
            "dateCreated": Timestamp()
        ]
        try await Firestore.firestore().collection("chatroom").document(chatroomId).setData(userData, merge: false)
    }
    
}













//    db.collection("messages").order(by: "sendTime").addSnapshotListener { [weak self] (querrySnapshot, error) in
//        if let e = error {
//            print(e)
//        } else {
//            self?.chatViewCellItems = []
//            if let snapshotDocments = querrySnapshot?.documents {
//                for doc in snapshotDocments {
//                    let data = doc.data()
//                    if let userName = data["userName"] as? String, let chatText = data["chatText"] as? String {
//                        let newMessage = UserMessages(userName: userName, userMessage: chatText)
//                        print(newMessage)
//                        self?.chatViewCellItems.append(newMessage)
//                        Task.detached { @MainActor in
//                            self?.tableView.reloadData()
//                            let indexPath = IndexPath(row: (self?.chatViewCellItems.count ?? 1) - 1, section: 0)
//                            self?.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    if let userName = Auth.auth().currentUser?.email, let chatText = chatTextField.text {
//        db.collection("messages").addDocument(data: ["userName" : userName, "chatText" : chatText, "sendTime" : Date().timeIntervalSince1970]) { error in
//            if let e = error {
//                print(e)
//            } else {
//                print("success")
//                Task.detached { @MainActor in
//                    self.chatTextField.text = ""
//                }
//            }
//        }
//    }
