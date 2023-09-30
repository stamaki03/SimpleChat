//
//  StorageManager.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/23.
//

import UIKit
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    func saveImage(data: Data, userId: String) async throws -> String {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let fileName = "\(userId).jpeg"
        let reference = Storage.storage().reference().child("users").child(userId).child(fileName)
        _ = try await reference.putDataAsync(data, metadata: meta)
        let downloadUrl = try await reference.downloadURL().absoluteString
        return downloadUrl
    }
    
    func deleteImage(userId: String) {
        Storage.storage().reference().child("users").child(userId).child("\(userId).jpeg").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func updateImage(image: UIImage) async throws {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        let uploadImage = image.jpegData(compressionQuality: 0.1)
        guard let data = uploadImage else { return }
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let reference = Storage.storage().reference().child("users").child(userId).child("\(userId).jpeg")
        _ = try await reference.putDataAsync(data, metadata: meta)
        let photoUrl = try await reference.downloadURL().absoluteString
        try UserManager.shared.updatePhotoUrl(userId: userId, photoUrl: photoUrl)
    }
}
