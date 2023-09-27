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
    
    func createUser(auth: AuthenticationModel, name: String, photoUrl: String?) async throws {
        let userData: [String:Any] = [
            "uid": auth.uid,
            "name": name,
            "email": auth.email ?? "",
            "photoUrl": photoUrl ?? "",
            "dateCreated": Timestamp()
        ]
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func deleteUser(userId: String) {
        Firestore.firestore().collection("users").document(userId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func fetchAllUser() async throws -> [FSUserModel] {
        var dbUserArray: [FSUserModel] = []
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        for document in snapshot.documents {
            let data = document.data()
            let dbUser = FSUserModel(uid: data["uid"] as! String, name: data["name"] as? String, email: data["email"] as? String, photoUrl: data["photoUrl"] as? String, dateCreated: data["dateCreated"] as? Date)
            dbUserArray.append(dbUser)
        }
        return dbUserArray
    }
    
    func fetchUser(userId: String) async throws -> FSUserModel {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        guard let data = snapshot.data(), let uid = data["uid"] as? String else { throw URLError(.badServerResponse) }
        let name = data["name"] as? String
        let email = data["email"] as? String
        let photoUrl = data["photoUrl"] as? String
        let chatroom = data["chatroom"] as? [String] ?? [String]()
        let dateCreated = data["dateCreated"] as? Date
        return FSUserModel(uid: uid, name: name, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    }
    
    func adUserTodChatroom(chatroomId: String, user: String) async throws {
        try await Firestore.firestore().collection("users").document(user).collection("chatroom").document(chatroomId).setData(["chatroomId": chatroomId])
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
