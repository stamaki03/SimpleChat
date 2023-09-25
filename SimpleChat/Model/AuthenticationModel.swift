//
//  AuthenticationModel.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/22.
//

import Foundation
import FirebaseAuth

struct AuthenticationModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
    
}
