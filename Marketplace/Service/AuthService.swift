//
//  AuthService.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 26.09.2026.
//

import Foundation
import FirebaseAuth

final class AuthService {
    
    private let auth = Auth.auth()
    
    func register(
        email: String,
        password: String
    ) async throws -> User {
        
        let result = try await auth.createUser(
            withEmail: email,
            password: password
        )
        
        return result.user
    }
    
    func login(
        email: String,
        password: String
    ) async throws -> User {
        
        let result = try await auth.signIn(
            withEmail: email,
            password: password
        )
        
        return result.user
    }
    
    func logout() throws {
        try auth.signOut()
    }
    
    func currentUser() -> User? {
        auth.currentUser
    }
}
