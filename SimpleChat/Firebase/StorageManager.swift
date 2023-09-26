//
//  StorageManager.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/23.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    func saveImage(data: Data, userId: String) async throws -> String {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let fileName = "\(UUID().uuidString).jpeg"
        let reference = Storage.storage().reference().child("users").child(userId).child(fileName)
        _ = try await reference.putDataAsync(data, metadata: meta)
        let downloadUrl = try await reference.downloadURL().absoluteString
        //guard let returnedPath = returnedMetaData.path else { throw URLError(.badServerResponse)}
        return downloadUrl
    }
}
