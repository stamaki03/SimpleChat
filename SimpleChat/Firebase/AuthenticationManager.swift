//
//  AuthenticationManager.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/22.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthenticationModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthenticationModel(user: user)
    }
    
    func createUser(email: String, password: String) async throws -> AuthenticationModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthenticationModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthenticationModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthenticationModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updateEmail(to: email)
    }
}
