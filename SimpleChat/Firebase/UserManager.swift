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
    
    func createManager(auth: AuthDataResultModel) async throws {
        let userData: [String:Any] = [
            "uid" : auth.uid,
            "name" : auth.name ?? "",
            "email" : auth.email ?? "",
            "photoUrl" : auth.photoUrl ?? "",
            "dateCreated" : Timestamp()
        ]
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
        
    }
    
    func getAllUser() async throws -> [DBuser] {
        var dbUserArray: [DBuser] = []
        
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        for document in snapshot.documents {
            let data = document.data()
            let dbUser = DBuser(uid: data["uid"] as! String, name: data["name"] as? String, email: data["email"] as? String, photoUrl: data["photoUrl"] as? String, dateCreated: data["dateCreated"] as? Date)
            dbUserArray.append(dbUser)
        }
        
        return dbUserArray
    }
    
    func getUser(userId: String) async throws -> DBuser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        guard let data = snapshot.data(), let uid = data["uid"] as? String else { throw URLError(.badServerResponse) }
        
        let name = data["name"] as? String
        let email = data["email"] as? String
        let photoUrl = data["photoUrl"] as? String
        let dateCreated = data["dateCreated"] as? Date
        
        return DBuser(uid: uid, name: name, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    }
        
}
