//
//  UserModel.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/19.
//

import UIKit

struct UserModel {
    let chatroomId: String
    let uid: String
    let name: String?
    let email: String?
    let photo: UIImage?
    let chatroom: [String?]
    let dateCreated: Date?
}
