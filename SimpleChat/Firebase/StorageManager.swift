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
    
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    func saveImage(data: Data, userId: String) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await storage.child("users").child(userId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returendName = returnedMetaData.name else { throw URLError(.badServerResponse)}
        return (returnedPath, returendName)
    }
    
    func getImage(userId: String, path: String) async throws {
        try await storage.child("users").child(userId).child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
}
