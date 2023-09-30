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
            "members": members
        ]
        try await Firestore.firestore().collection("chatroom").document(chatroomId).setData(userData, merge: false)
    }
    
    func addDocument(chatroomId: String, userId: String, chatText: String) async throws {
        try await Firestore.firestore().collection("chatroom").document(chatroomId).collection("chats").addDocument(data: ["userId" : userId, "chatText" : chatText, "sendTime" : Timestamp()])
    }
    
    func deleteChatroom(chatroomId: String) async throws {
        try await Firestore.firestore().collection("chatroom").document(chatroomId).delete()
    }
}
