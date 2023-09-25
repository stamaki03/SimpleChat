//
//  UserManager.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    func createUser(auth: AuthDataResultModel, name: String, photoUrl: String?) async throws {
        let userData: [String:Any] = [
            "uid": auth.uid,
            "name": name,
            "email": auth.email ?? "",
            "photoUrl": photoUrl ?? "",
            "chatroom": [String](),
            "dateCreated": Timestamp()
        ]
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
        
    }
    
    func fetchAllUser() async throws -> [DBuser] {
        var dbUserArray: [DBuser] = []
        
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        for document in snapshot.documents {
            let data = document.data()
            let dbUser = DBuser(uid: data["uid"] as! String, name: data["name"] as? String, email: data["email"] as? String, photoUrl: data["photoUrl"] as? String, chatroom: data["chatroom"] as? [String] ?? [String](), dateCreated: data["dateCreated"] as? Date)
            dbUserArray.append(dbUser)
        }
        
        return dbUserArray
    }
    
    func fetchUser(userId: String) async throws -> DBuser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        guard let data = snapshot.data(), let uid = data["uid"] as? String else { throw URLError(.badServerResponse) }
        
        let name = data["name"] as? String
        let email = data["email"] as? String
        let photoUrl = data["photoUrl"] as? String
        let chatroom = data["chatroom"] as? [String] ?? [String]()
        let dateCreated = data["dateCreated"] as? Date
        
        return DBuser(uid: uid, name: name, email: email, photoUrl: photoUrl, chatroom: chatroom, dateCreated: dateCreated)
    }
    
    func adUserTodChatroom(chatroomId: String, user: String) async throws {
        try await Firestore.firestore().collection("users").document(user).updateData([
            "chatroom": FieldValue.arrayUnion([chatroomId])
        ])
    }
        
    func fetchOtherMember(chatroomId: String) async throws -> String {
        var otherUser: String?
        
        let chatroomInfo = try await Firestore.firestore().collection("chatroom").document(chatroomId).getDocument()
        guard let data = chatroomInfo.data() else { throw URLError(.badServerResponse )}
        let currentUser = try AuthenticationManager.shared.getAuthenticatedUser().uid
        if let members = data["members"] as? [String] {
            for member in members {
                if member != currentUser {
                    otherUser = member
                }
            }
        }
        return otherUser ?? ""
    }
}
