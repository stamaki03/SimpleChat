//
//  FSUserModel.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/23.
//

import Foundation

struct FSUserModel {
    let uid: String
    let name: String?
    let email: String?
    let photoUrl: String?
    let chatroom: [String?]
    let dateCreated: Date?
}
