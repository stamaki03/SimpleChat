//
//  AuthDataResultModel.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/22.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let name: String?
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.name = user.displayName
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
    
}
