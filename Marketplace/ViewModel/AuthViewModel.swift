//
//  AuthViewModel.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 26.09.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var isLoading = true
    @Published var errorMessage = ""
    
    private let authService = AuthService()
    private let db = Firestore.firestore()
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthListener()
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    private func setupAuthListener() {
        authStateListener = Auth.auth()
            .addStateDidChangeListener { [weak self] _, user in
                
                Task { @MainActor in
                    self?.isAuthenticated = user != nil
                    self?.isLoading = false
                }
            }
    }
    
    func register(
        email: String,
        password: String
    ) async {
        
        isLoading = true
        errorMessage = ""
        
        do {
            let user = try await authService.register(
                email: email,
                password: password
            )
            
            try await createUserDocument(
                user: user
            )
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func login(
        email: String,
        password: String
    ) async {
        
        isLoading = true
        errorMessage = ""
        
        do {
            _ = try await authService.login(
                email: email,
                password: password
            )
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {
        do {
            try authService.logout()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func createUserDocument(
        user: User
    ) async throws {
        try await db
            .collection("users")
            .document(user.uid)
            .setData([
                "email": user.email ?? "",
                "createdAt": FieldValue.serverTimestamp()
            ])
    }
}
